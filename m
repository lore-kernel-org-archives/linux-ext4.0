From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
Date: Fri, 17 Aug 2012 08:47:04 +0200
Message-ID: <502DE8E8.5080000@gmail.com>
References: <502CC4BA.3040702@gmail.com> <20120816163904.GA17526@quack.suse.cz> <20120816191909.GC31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: bharrosh@panasas.com, bhalevy@tonian.com,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	osd-dev@open-osd.org, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, dushistov@mail.ru
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120816191909.GC31346@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il 16/08/2012 21:19, Theodore Ts'o ha scritto:
> On Thu, Aug 16, 2012 at 06:39:04PM +0200, Jan Kara wrote:
>> On Thu 16-08-12 12:00:26, Marco Stornelli wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> Replaced lock and unlock super with a new fs mutex s_lock.
>>    Hum, is the lock needed at all? Remount & unfreeze both run with s_umount
>> held for writing. Thus we already have exclusion between these two calls.
>> The same seems to hold for ext4 BTW.
>
> Agreed, it's not clear lock_super() is needed at all for ext4 at this
> point.
>
> 	     	       		       	      - Ted
>

Great. I'll remove the calls for ext3/ext4 when I'll submit the second 
version of the patch.

Thanks for your feedback,

Marco
