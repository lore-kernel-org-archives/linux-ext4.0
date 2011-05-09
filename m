From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [PATCH v2] Adding support to freeze and unfreeze a journal
Date: Mon, 09 May 2011 16:49:24 +0300
Message-ID: <4DC7F0E4.5070507@canonical.com>
References: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca> <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com> <20110509095313.GB4122@quack.suse.cz>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, toshi.okajima@jp.fujitsu.com,
	marco.stornelli@gmail.com, tytso@mit.edu, m.mizuma@jp.fujitsu.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110509095313.GB4122@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/09/2011 12:53 PM, Jan Kara wrote:
> On Sat 07-05-11 23:04:22, Surbhi Palande wrote:
>> +void jbd2_journal_thaw(journal_t * journal)
>> +{
>> +	write_lock(&journal->j_state_lock);
>> +	journal->j_flags = journal->j_flags&= ~JBD2_FROZEN;
>> +	write_unlock(&journal->j_state_lock);
>> +	smp_wmb();
>    Why is here the smp_wmb()? The write is inside a rw-lock so it cannot be
> reordered. Also wake_up() is protected by queue->lock so I don't see the
> need for a barrier.

Ok, thanks for letting me know. I was under the impression that a 
reorder was possible in case of SMP. I will rewrite the patch with this 
change and the one that Marco Stornelli suggested as well.

Thanks a lot!

Warm Regards,
Surbhi.

>
>> +	wake_up(&journal->j_wait_frozen);
>> +}
>> +EXPORT_SYMBOL(jbd2_journal_thaw);
>
> 								Honza

