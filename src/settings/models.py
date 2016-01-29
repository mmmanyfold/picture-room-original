from django.db import models

class Setting(models.Model):
    key = models.CharField(max_length=100)
    value = models.CharField(max_length=255)

    def __unicode__(self):
        return "%s : %s" % (self.key, self.value)

    def save(self, *args, **kwargs):
        # only one setting per key
        Setting.objects.filter(key=self.key).exclude(pk=self.pk).delete()
        super(Setting, self).save(*args, **kwargs)
