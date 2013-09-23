From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: remove quota docs if not configured in
Date: Mon, 23 Sep 2013 14:09:29 -0500
Message-ID: <524091E9.4070105@redhat.com>
References: <50B504C4.6090504@redhat.com> <50B50804.6020309@redhat.com> <50B6F707.60308@redhat.com> <51FBD4C1.9060106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bert.Deknuydt@esat.kuleuven.be
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3IWTKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Sep 2013 15:10:54 -0400
In-Reply-To: <51FBD4C1.9060106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/2/13 10:48 AM, Eric Sandeen wrote:
> On 11/28/12 11:47 PM, Eric Sandeen wrote:
>> If quota isn't turned on with --enable-quota, then comment
>> quota documentation out of the mke2fs manpage.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> first time I've mucked with subst, dunno if this is right
>> but it seems to work :)
> 
> Going through old patches - ping on this one?

And again.  Ping?

-Eric

> -Eric
> 
>> diff --git a/configure.in b/configure.in
>> index bc8d1e8..2d431bd 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -565,6 +565,8 @@ AC_SUBST(BLKID_CMT)
>>  dnl
>>  dnl handle --enable-quota
>>  dnl
>> +QUOTA_MAN_COMMENT='.\"'
>> +AC_SUBST(QUOTA_MAN_COMMENT)
>>  PKG_PROG_PKG_CONFIG
>>  AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota support])
>>  AC_ARG_ENABLE([quota],
>> @@ -575,6 +577,8 @@ then
>>  else
>>  	AC_DEFINE(CONFIG_QUOTA, 1)
>>  	AC_MSG_RESULT([Enabling quota support])
>> +	QUOTA_MAN_COMMENT=""
>> +	AC_SUBST(QUOTA_MAN_COMMENT)
>>  fi
>>  ,
>>  AC_MSG_RESULT([Disabling quota support by default])
>> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
>> index d4fbe00..92cae74 100644
>> --- a/misc/mke2fs.8.in
>> +++ b/misc/mke2fs.8.in
>> @@ -275,13 +275,13 @@ as default.
>>  .TP
>>  .BI nodiscard
>>  Do not attempt to discard blocks at mkfs time.
>> -.TP
>> -.BI quotatype
>> -Specify which quota type ('usr' or 'grp') is to be initialized. This
>> -option has any effect only if
>> -.B quota
>> -feature is set. Without this extended option, the default behavior is to
>> -initialize both user and group quotas.
>> +@QUOTA_MAN_COMMENT@.TP
>> +@QUOTA_MAN_COMMENT@.BI quotatype
>> +@QUOTA_MAN_COMMENT@Specify which quota type ('usr' or 'grp') is to be initialized. This
>> +@QUOTA_MAN_COMMENT@option has any effect only if
>> +@QUOTA_MAN_COMMENT@.B quota
>> +@QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default behavior is to
>> +@QUOTA_MAN_COMMENT@initialize both user and group quotas.
>>  .RE
>>  .TP
>>  .BI \-f " fragment-size"
>> @@ -555,11 +555,11 @@ option).
>>  .B large_file
>>  Filesystem can contain files that are greater than 2GB.  (Modern kernels
>>  set this feature automatically when a file > 2GB is created.)
>> -.TP
>> -.B quota
>> -Create quota inodes (inode# 3 for userquota and inode# 4 for group quota) and
>> -set them in the superblock.  With this feature, the quotas will be enabled
>> -automatically when the filesystem is mounted.
>> +@QUOTA_MAN_COMMENT@.TP
>> +@QUOTA_MAN_COMMENT@.B quota
>> +@QUOTA_MAN_COMMENT@Create quota inodes (inode# 3 for userquota and inode# 4 for group quota) and
>> +@QUOTA_MAN_COMMENT@set them in the superblock.  With this feature, the quotas will be enabled
>> +@QUOTA_MAN_COMMENT@automatically when the filesystem is mounted.
>>  .TP
>>  .B resize_inode
>>  Reserve space so the block group descriptor table may grow in the future.
>> diff --git a/util/subst.conf.in b/util/subst.conf.in
>> index 0e074d8..64fde7a 100644
>> --- a/util/subst.conf.in
>> +++ b/util/subst.conf.in
>> @@ -18,3 +18,5 @@ $prefix			@prefix@
>>  # Enable the documentation for the journal device mke2fs, tune2fs, and
>>  # e2fsck's man page
>>  JDEV			
>> +# Enable documentation for quota feature in mke2fs
>> +QUOTA_MAN_COMMENT	@QUOTA_MAN_COMMENT@
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

