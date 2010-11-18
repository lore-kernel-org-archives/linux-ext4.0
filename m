From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 17:09:46 -0500
Message-ID: <4CE5A42A.5080308@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <20101118180557.GU22787@shareable.org> <20101118193255.GE1594@arch.trippelsdorf.de> <4CE59E86.1080603@teksavvy.com> <20101118215008.GA1556@arch.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jamie Lokier <jamie@shareable.org>, Jeff Moyer <jmoyer@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101118215008.GA1556@arch.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10-11-18 04:50 PM, Markus Trippelsdorf wrote:
> On 2010.11.18 at 16:45 -0500, Mark Lord wrote:
>> On 10-11-18 02:32 PM, Markus Trippelsdorf wrote:
>>> On 2010.11.18 at 18:05 +0000, Jamie Lokier wrote:
>>>> Online trim may be slow, but offline would be awfully inconvenient
>>>> when an fs is big and needed for a live system, or when it's your root fs.
>>>
>>> You can call FITRIM from a running system. Infact I run it once per week
>>> as a cron job on my (mounted) root fs.
>>
>>
>> Ditto for wiper.sh.
>
> But I always thought that wiper has no access to the filesystem
> internals. So there is always a chance that you write to a sector that
> wiper.sh is currently trimming. FITRIM should be safer in this regard.


No, wiper.sh is very safe for online TRIM.
It reserves the blocks before trimming them, so nothing else can write to them.

The danger with wiper.sh, is that WHILE it is running, it reserves most
of the free space of the filesystem.  So if there are other apps writing
tons of new data to the drive, while not freeing up old data, the system
can run low on diskspace for a moment.

wiper.sh counters that by not reserving/trimming *everything* when run online,
leaving a reasonable amount of scratch space available for other apps during the 
run.

This is where having a fully capable FITRIM, with multi-range TRIMs, would be 
useful.

Cheers
