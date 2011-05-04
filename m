From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Wed, 04 May 2011 09:30:27 -0500
Message-ID: <4DC16303.3080106@redhat.com>
References: <20110331234050.GD2904@dastard> <20110401140856.GA5311@quack.suse.cz> <20110406054005.GD31057@dastard> <20110406061856.GC23285@quack.suse.cz> <20110406112135.GE31057@dastard> <4DBE746F.3090707@ubuntu.com> <20110502105629.GA4556@quack.suse.cz> <4DBE9537.4050708@ubuntu.com> <20110502122055.GB5855@quack.suse.cz> <4DBEA3DF.1060306@ubuntu.com> <20110502131619.GC5855@quack.suse.cz> <4DBEB025.90704@ubuntu.com> <4DBEB9E7.9070407@redhat.com> <4DBFAE44.2080000@ubuntu.com> <4DC0622A.3090201@redhat.com> <4DC10DBC.6010607@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: surbhi.palande@ubuntu.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DC10DBC.6010607@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/4/11 3:26 AM, Surbhi Palande wrote:
> On 05/03/2011 11:14 PM, Eric Sandeen wrote:
>> On 5/3/11 2:27 AM, Surbhi Palande wrote:

...

>>> Should this not be reverted? I think that its a lot easier to
>>> stop a transaction between a freeze and a thaw that way! If you
>>> agree, can I send a patch for the same?
>> Only if you want the kernel to start spewing "BUG!" messages
>> again...
>> 
>> -Eric
> But, then you need a much more complicated way to stop accepting the
> transactions and the writes between the freeze and the thaw? (in the
> write path and the read path)? Is this not much simpler?

I just cannot see how a solution which leads to:

>>      ================================================
>>      [ BUG: lock held when returning to user space! ]
>>      ------------------------------------------------
>>      lvcreate/1075 is leaving the kernel with locks still held!
>>      1 lock held by lvcreate/1075:
>>       #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
>>      jbd2_journal_lock_updates+0xe1/0xf0


can be considered viable.

You are welcome to send the patch, and if other ext4 devs concur with it then I'll be outvoted. :)

-Eric

