From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sat, 01 Jan 2011 12:20:04 -0500
Message-ID: <4D1F6244.7050203@redhat.com>
References: <201012280953.46149.kernel@kolivas.org>	<20101228025343.GD10149@thunk.org>	<20101228081917.GA1351@bitwizard.nl> <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-usb@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12/28/2010 05:30 AM, Amir Goldstein wrote:
> On Tue, Dec 28, 2010 at 10:19 AM, Rogier Wolff<R.E.Wolff@bitwizard.nl>  wrote:
>> On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
>>> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
>>>> [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode.
>>>> Opts: (null)
>>>> [1048702.736011] EXT4-fs (sde8): error count: 3
>>>> [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
>>>> ext4_journal_start_sb:251
>>>> [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719
>>> That's actually not an error.  It's a report which is generated every
>>> 24 hours, indicating that there has been 3 errors since the last time
>>> the error count has been cleared, with the first error taking place at
>>> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
>>> ext4_journal_start_sb(), at line 251, and the most recent error taking
>>> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
>>> ext4_put_super() at line 719.  This is a new feature which was added
>>> in 2.6.36.
>> Nice. But the issue you're not mentioning is: What errors could have
>> happened on the 6th of november? Should Con worry about those errors?
>>
> Ted,
>
> I would like to use this opportunity to remind you about my
> record_journal_errstr()
> implementation, see:
> https://github.com/amir73il/ext4-snapshots/blob/next3-stable/fs/next3/super.c#L157
>
> It records the initial errors messages (which I found to be the most
> interesting),
> in a message buffer on the unused space after the journal super block
> (3K on a 4K block fs).
>
> fsck prints out those messages and clears the buffer.
> In under a year of Next3 fs in beta and production, it has helped me many times
> to analyse bugs post-mortem and find the problem.
>
> If there is demand, I can post the patch for Ext4.
>
> Amir.

I do think that this sounds like a useful addition - should be very useful in 
doing post mortem analysis...

Thanks!

Ric
