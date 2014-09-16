From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v3 1/4] quota: add project quota support
Date: Tue, 16 Sep 2014 16:15:35 +0800
Message-ID: <CAPTn0cBXjePDOmT+dr4VOVs1r9sKbFC16pJv1fTc_oHLNYLsDA@mail.gmail.com>
References: <CAPTn0cAOeQ_nyKx5k+kJOzx17tq+5WtyrMhBE8bpFCKx0UecGw@mail.gmail.com>
	<20140910164559.GA10507@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53494 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaIPIPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Sep 2014 04:15:36 -0400
In-Reply-To: <20140910164559.GA10507@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:45 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 10-09-14 11:52:35, Li Xi wrote:
>> Adds general codes to enforces project quota limits
>>
>> This patch adds support for a new quota type PRJQUOTA for project quota
>> enforcement. Also a new method get_projid() is added into dquot_operations
>> structure.
>>
>   One general note:
>   Your mail client has apparently mangled the patch (replaced tabs with
> spaces). Please resend patches using git-send-email or some other email
> client that doesn't do this so that they can be applied cleanly.
>
>   Some other comments below.
>
>> Signed-off-by: Li Xi <lixi <at> ddn.com>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>> Index: linux.git/fs/quota/dquot.c
>> ===================================================================
>> --- linux.git.orig/fs/quota/dquot.c
>> +++ linux.git/fs/quota/dquot.c
>> @@ -161,6 +161,19 @@ static struct quota_module_name module_n
>>  /* SLAB cache for dquot structures */
>>  static struct kmem_cache *dquot_cachep;
>>
>> +static inline unsigned long compat_qtype2bits(int type)
>> +{
>> +#ifdef CONFIG_QUOTA_PROJECT
>   I don't find CONFIG_QUOTA_PROJECT all that useful. If someone is building
> a kernel with CONFIG_QUOTA enabled (i.e., a kernel for a server), he can
> well spare those few kilobytes for project quota support and it makes the
> code somewhat nicer. So I would just remove this config option.
>
>> +    unsigned long qtype_bits = QUOTA_ALL_BIT;
>> +#else
>> +    unsigned long qtype_bits = QUOTA_USR_BIT | QUOTA_GRP_BIT;
>> +#endif
>> +    if (type != -1) {
>> +        qtype_bits = 1 << type;
>> +    }
>> +    return qtype_bits;
>> +}
>> +
>>  int register_quota_format(struct quota_format_type *fmt)
>>  {
>>      spin_lock(&dq_list_lock);
>> @@ -250,7 +263,8 @@ struct dqstats dqstats;
>>  EXPORT_SYMBOL(dqstats);
>>
>>  static qsize_t inode_get_rsv_space(struct inode *inode);
>> -static void __dquot_initialize(struct inode *inode, int type);
>> +static void __dquot_initialize(struct inode *inode,
>> +                   unsigned long qtype_bits);
>   I've noticed you are changing interface of several functions from taking
> a type number (or -1) to taking a bitmask. I guess it's because of
> CONFIG_QUOTA_PROJECT or is there also any other reason? If we get rid of
> that config, we won't need this change either, right?
>
> ...
>> Index: linux.git/include/uapi/linux/quota.h
>> ===================================================================
>> --- linux.git.orig/include/uapi/linux/quota.h
>> +++ linux.git/include/uapi/linux/quota.h
>> @@ -36,11 +36,12 @@
>>  #include <linux/errno.h>
>>  #include <linux/types.h>
>>
>> -#define __DQUOT_VERSION__    "dquot_6.5.2"
>> +#define __DQUOT_VERSION__    "dquot_6.6.0"
>>
>> -#define MAXQUOTAS 2
>> +#define MAXQUOTAS 3
>   Hum, actually this isn't so simple. MAXQUOTAS is used in several
> filesystems - ext3, ext4, ocfs2, reiserfs, gfs2 - and just bumping up
> MAXQUOTAS can have unexpected consequences for them (they won't have
> properly initialized data structures for new quota type). So what we have
> to do as a preparatory step is to make these filesystems define their own
> MAXQUOTAS value (like EXT3_MAXQUOTAS, ...). I'll take care of that.
Yeah, you are right. It is likely that a new MAXQUOTAS value will hurt other
file systems. And I saw your patch for it. I will use EXT4_MAXQUOTAS
in Ext4 instead.

However, the general codes in fs/quota or head files like quotaops.h use
MAXQUOTAS heavily too. I guess I have no better choice but replace
MAXQUOTAS there with a new macro, e.g. MAXQUOTAS_NEW (3). I will handle
the interfaces carefully so that they remain exactly the same semantics. Do you
have any better idea?

The reason why I replaced the sepcail type number (i.e. -1) with a bitmask is
that I thought there might be some cases when we want to operate on some
of the quota types rather than all of them. When the number of quota
types was 2,
-1 is alright. But since we are using 3 quota types, it becomes a
problem. In order
to keep the compatibility of quota interfaces, we need to pass only
QUOTA_USR_BIT | QUOTA_GRP_BIT to functions like __dquot_initialize().
But for ext4, we need to pass QUOTA_ALL_BIT. This is an important use case
which -1 quota type is not able to satisfy.

So, in general, I will:
1) keep MAXQUOTAS value as 2;
2) replace MAXQUOTAS in genral codes with MAXQUOTAS_NEW (3);
3) use EXT4_MAXQUOTAS in Ext4 codes.

Please let me know if you have any suggestions.

Regards,
                                                         - Li Xi
