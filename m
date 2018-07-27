From: Jeremy Cline <jcline@redhat.com>
Subject: Re: [PATCH 1/3] ext4: super: Fix spectre gadget in ext4_quota_on
Date: Fri, 27 Jul 2018 15:17:14 -0400
Message-ID: <d4607577-c5e7-687f-43d6-9a7c9ed76479@redhat.com>
References: <20180727162357.30801-1-jcline@redhat.com>
 <20180727162357.30801-2-jcline@redhat.com>
 <20180727174654.bnooz26puuo7456w@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180727174654.bnooz26puuo7456w@treble>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/27/2018 01:46 PM, Josh Poimboeuf wrote:
> On Fri, Jul 27, 2018 at 04:23:55PM +0000, Jeremy Cline wrote:
>> 'type' is a user-controlled value used to index into 's_qf_names', which
>> can be used in a Spectre v1 attack. Clamp 'type' to the size of the
>> array to avoid a speculative out-of-bounds read.
>>
>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jeremy Cline <jcline@redhat.com>
>> ---
>>  fs/ext4/super.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 6480e763080f..c04a09b51742 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -40,6 +40,7 @@
>>  #include <linux/crc16.h>
>>  #include <linux/dax.h>
>>  #include <linux/cleancache.h>
>> +#include <linux/nospec.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/iversion.h>
>>  
>> @@ -5559,6 +5560,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>>  	if (path->dentry->d_sb != sb)
>>  		return -EXDEV;
>>  	/* Journaling quota? */
>> +	type = array_index_nospec(type, EXT4_MAXQUOTAS);
>>  	if (EXT4_SB(sb)->s_qf_names[type]) {
>>  		/* Quotafile not in fs root? */
>>  		if (path->dentry->d_parent != sb->s_root)
> 
> Generally we try to put the array_index_nospec() close to the bounds
> check for which it's trying to prevent speculation past.
> 
> In this case, I'd expect the EXT4_MAXQUOTAS bounds check to be in
> do_quotactl(), but it seems to be missing:
> 
> 	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
> 		return -EINVAL;
> 
> Also it looks like XQM_MAXQUOTAS, MAXQUOTAS, and EXT4_MAXQUOTAS all have
> the same value (3).  Maybe they can be consolidated to just use
> MAXQUOTAS everywhere?  Then the nospec would be simple:
> 
> 	if (type >= MAXQUOTAS)
> 		return -EINVAL;
> 	type = array_index_nospec(type, MAXQUOTAS);
> 
> Otherwise I think we may need to disperse the array_index_nospec calls
> deeper in the callchain.
> 

Makes sense, that would be much nicer. I looked into the history a bit,
EXT4_MAXQUOTAS was adjusted from 2 to 3 in v4.5 so a backport of this to
v4.4 or earlier would require a bit of adjustment, but XQM_MAXQUOTAS
looks to have been 3 for a very long time.

I'll see about consolidating them and adjusting this patch.

Thanks,
Jeremy
