From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] e4defrag: Add option -m mtab to e4defrag
Date: Thu, 18 Oct 2012 08:27:50 +0530
Message-ID: <CAOiN93nkfPQN=Niu4JF5_h0ebh5pSJ32Q-eSqTCnna8zDcxSAQ@mail.gmail.com>
References: <1350492760-2106-1-git-send-email-ashish.sangwan2@gmail.com>
	<507EE5B2.3000506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57500 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2JRC5w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 22:57:52 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so4842512vcb.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 19:57:52 -0700 (PDT)
In-Reply-To: <507EE5B2.3000506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 17, 2012 at 10:36 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 10/17/12 11:52 AM, Ashish Sangwan wrote:
>> Currently, e4defrag will not work on machines where /etc/mtab is not present
>> OR is empty.
>> This patch does 3 things:
>> a) Add option "-m mtab" to e4defrag so that user can specify any file to
>> be scanned for otbtaining mounted filesystems info.
>
> Under what conditions would this be useful; i.e. when is mtab information
> ever in a file other than /etc/mtab?

On embedded systems usually /etc is read-only. In that case /etc/mtab,
though  present, is empty.
When we tried to run e4defrag on our system, it gave segfault due to
the reasons mentioned in patch.

Then we look into xfs_fsr and found that it has this -m mtab option
due to which it worked without any problem
on our system. Also, xfs_fsr scans /proc/mounts first. So we changed
e4defrag accordingly.
>
> Thanks,
> -Eric
>
>> b) If mtab option is not specified, first we try to scan /proc/mounts, if failed
>> to access this file, we try with /etc/mtab.
>> c) In function is_ext4, check if the varibale "mnt_type" is null before
>> calling strcmp, otherwise segfault would occur if mtab is empty.
>>
>> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  misc/e4defrag.8.in |   10 ++++++++++
>>  misc/e4defrag.c    |   34 ++++++++++++++++++++++------------
>>  2 files changed, 32 insertions(+), 12 deletions(-)
>>
>> diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
>> index 75e1bc9..7090e51 100644
>> --- a/misc/e4defrag.8.in
>> +++ b/misc/e4defrag.8.in
>> @@ -9,6 +9,9 @@ e4defrag \- online defragmenter for ext4 filesystem
>>  [
>>  .B \-v
>>  ]
>> +[
>> +.B \-m mtab
>> +]
>>  .I target
>>  \&...
>>  .SH DESCRIPTION
>> @@ -57,6 +60,13 @@ is never defragmented.
>>  .B \-v
>>  Print error messages and the fragmentation count before and after defrag for
>>  each file.
>> +.TP
>> +.B \-m mtab
>> +This option will specify the file to be scanned for obtaining mounted filesystems
>> +information. If this option is not specified, the default is to use
>> +.B /proc/mounts .
>> +If this file is not accessible, e4defrag will try to get required information from
>> +.B /etc/mtab
>>  .SH NOTES
>>  .B e4defrag
>>  does not support swap file, files in lost+found directory, and files allocated
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index 4b31d03..3567e9f 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -123,6 +123,7 @@
>>  #define NGMSG_FILE_OPEN              "Failed to open"
>>  #define NGMSG_FILE_UNREG     "File is not regular file"
>>  #define NGMSG_LOST_FOUND     "Can not process \"lost+found\""
>> +#define _PATH_PROC_MOUNTS       "/proc/mounts"
>>
>>  /* Data type for filesystem-wide blocks number */
>>  typedef unsigned long long ext4_fsblk_t;
>> @@ -262,10 +263,8 @@ static int fallocate64(int fd, int mode, loff_t offset, loff_t len)
>>   * @dir_path_len:    the length of directory.
>>   */
>>  static int get_mount_point(const char *devname, char *mount_point,
>> -                                                     int dir_path_len)
>> +                        int dir_path_len, const char *mtab)
>>  {
>> -     /* Refer to /etc/mtab */
>> -     const char      *mtab = MOUNTED;
>>       FILE            *fp = NULL;
>>       struct mntent   *mnt = NULL;
>>       struct stat64   sb;
>> @@ -278,7 +277,7 @@ static int get_mount_point(const char *devname, char *mount_point,
>>
>>       fp = setmntent(mtab, "r");
>>       if (fp == NULL) {
>> -             perror("Couldn't access /etc/mtab");
>> +             printf("Couldn't access %s\n", mtab);
>>               return -1;
>>       }
>>
>> @@ -313,14 +312,12 @@ static int get_mount_point(const char *devname, char *mount_point,
>>   *
>>   * @file:            the file's name.
>>   */
>> -static int is_ext4(const char *file, char *devname)
>> +static int is_ext4(const char *file, char *devname, const char *mtab)
>>  {
>>       int     maxlen = 0;
>>       int     len, ret;
>>       FILE    *fp = NULL;
>>       char    *mnt_type = NULL;
>> -     /* Refer to /etc/mtab */
>> -     const char      *mtab = MOUNTED;
>>       char    file_path[PATH_MAX + 1];
>>       struct mntent   *mnt = NULL;
>>       struct statfs64 fsbuf;
>> @@ -345,7 +342,7 @@ static int is_ext4(const char *file, char *devname)
>>
>>       fp = setmntent(mtab, "r");
>>       if (fp == NULL) {
>> -             perror("Couldn't access /etc/mtab");
>> +             printf("Couldn't access %s", mtab);
>>               return -1;
>>       }
>>
>> @@ -374,6 +371,10 @@ static int is_ext4(const char *file, char *devname)
>>       }
>>
>>       endmntent(fp);
>> +     if (mnt_type == NULL) {
>> +             printf("Could not get mount information from %s\n", mtab);
>> +             return -1;
>> +     }
>>       if (strcmp(mnt_type, FS_EXT4) == 0) {
>>               FREE(mnt_type);
>>               return 0;
>> @@ -1724,6 +1725,7 @@ int main(int argc, char *argv[])
>>       int     success_flag = 0;
>>       char    dir_name[PATH_MAX + 1];
>>       char    dev_name[PATH_MAX + 1];
>> +     char *mtab = NULL;
>>       struct stat64   buf;
>>       ext2_filsys fs = NULL;
>>
>> @@ -1731,7 +1733,7 @@ int main(int argc, char *argv[])
>>       if (argc == 1)
>>               goto out;
>>
>> -     while ((opt = getopt(argc, argv, "vc")) != EOF) {
>> +     while ((opt = getopt(argc, argv, "vcm:")) != EOF) {
>>               switch (opt) {
>>               case 'v':
>>                       mode_flag |= DETAIL;
>> @@ -1739,11 +1741,19 @@ int main(int argc, char *argv[])
>>               case 'c':
>>                       mode_flag |= STATISTIC;
>>                       break;
>> +             case 'm':
>> +                     mtab = optarg;
>> +                     break;
>>               default:
>>                       goto out;
>>               }
>>       }
>> -
>> +     if (!mtab) {
>> +             if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
>> +                     mtab = _PATH_PROC_MOUNTS;
>> +             else
>> +                     mtab = _PATH_MOUNTED;
>> +     }
>>       if (argc == optind)
>>               goto out;
>>
>> @@ -1797,7 +1807,7 @@ int main(int argc, char *argv[])
>>               if (S_ISBLK(buf.st_mode)) {
>>                       /* Block device */
>>                       strncpy(dev_name, argv[i], strnlen(argv[i], PATH_MAX));
>> -                     if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
>> +                     if (get_mount_point(argv[i], dir_name, PATH_MAX, mtab) < 0)
>>                               continue;
>>                       if (lstat64(dir_name, &buf) < 0) {
>>                               perror(NGMSG_FILE_INFO);
>> @@ -1833,7 +1843,7 @@ int main(int argc, char *argv[])
>>                * filesystem type checked in get_mount_point()
>>                */
>>               if (arg_type == FILENAME || arg_type == DIRNAME) {
>> -                     if (is_ext4(argv[i], dev_name) < 0)
>> +                     if (is_ext4(argv[i], dev_name, mtab) < 0)
>>                               continue;
>>                       if (realpath(argv[i], dir_name) == NULL) {
>>                               perror("Couldn't get full path");
>>
>
