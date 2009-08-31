From: david@lang.hm
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Mon, 31 Aug 2009 08:45:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908310844230.6822@asgard.lang.hm>
References: <20090831005426.13607.qmail@science.horizon.com> <20090831105645.GD1353@ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: George Spelvin <linux@horizon.com>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752979AbZHaPqW@vger.kernel.org>
In-Reply-To: <20090831105645.GD1353@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 31 Aug 2009, Pavel Machek wrote:

>> Actually, there is something the file system can do to make journaling
>> safe on degraded RAIDs: make the (checksummed) journal blocks equal to
>> the RAID stripe size.  Or, equivalently, pad out to the RAID stripe
>> size each commit.
>>
>> This sometimes leads to awkward block sizes, but while writing
>> to any *one* stripe on a degraded RAID-5 endangers the others, you
>> can write to *all* of them with the usual semantics.
>
> Well, that would work... but you'd also have to journal data, with the
> same block size. Not exactly fast, but at least safe...
>
>> That's one thing I really like about ZFS: its policy of "don't trust
>> the disks."  If nothing else, simply telling you "your disks f*ed up,
>> and I caught them doing it", instead of the usual mysterious corruption
>> detectec three months later, is tremendoudly useful information.
>
> The more I learn about storage, the more I like idea of zfs. Given the
> subtle issues between filesystem and raid layer, integrating them just
> makes sense.

note that all that zfs does is tell you that you already lost data (and 
then only if the checksumming algorithm would be invalid on a blank block 
being returned), it doesn't protect your data.

David Lang
