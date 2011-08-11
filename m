From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Thu, 11 Aug 2011 15:08:23 -0600
Message-ID: <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58554 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HKVIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 17:08:24 -0400
In-Reply-To: <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-11, at 9:01 AM, Lukas Czerner wrote:
> On Tue, 28 Jun 2011, Lukas Czerner wrote:
>> Data journalling mode (data=journal) is known to be neglected by
>> developers and only minority of people is actually using it. This
>> mode is also less tested than the other two modes by the developers.
>> 
>> This creates a dangerous combination, because the option which seems
>> *safer* is actually less safe the others. So this commit adds a warning
>> message in case that data=journal mode is used, so the user is informed
>> that the mode might be removed in the future.
> 
> Any comments on this ? Is that feasible to remove is someday ?

I'm less in favour of removing data=journal.  Jan made some fixes to
data=journal mode in the last few weeks, which means that people are
still using this.

>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>> fs/ext4/super.c |    5 +++++
>> 1 files changed, 5 insertions(+), 0 deletions(-)
>> 
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 9ea71aa..9d189cf 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1631,6 +1631,11 @@ static int parse_options(char *options, struct super_block *sb,
>> 			sbi->s_min_batch_time = option;
>> 			break;
>> 		case Opt_data_journal:
>> +			ext4_msg(sb, KERN_WARNING,
>> +				 "Using data=journal may be removed in the "
>> +				 "future. Please, contact "
>> +				 "linux-ext4@vger.kernel.org if you are "
>> +				 "using this feature.");
>> 			data_opt = EXT4_MOUNT_JOURNAL_DATA;
>> 			goto datacheck;
>> 		case Opt_data_ordered:
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





