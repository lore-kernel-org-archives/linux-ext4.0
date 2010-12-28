From: blp@cs.stanford.edu (Ben Pfaff)
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 07:02:06 -0800
Message-ID: <87wrmu54b5.fsf@benpfaff.org>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org> <4D19BEF1.9010708@shiftmail.org>
	<20101228143255.GI10149@thunk.org>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-usb@vger.kernel.org, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> On Tue, Dec 28, 2010 at 11:41:53AM +0100, torn5 wrote:
>> 
>> This is going to be a faq...
>> I suppose the datetime is encoded (what format is that?) in that
>> long number after "at".
>
> Number of seconds since January 1st, 1970 midnight GMT.  (Standard
> Unix-time format).  It's hard for the kernel to decode it since it
> doesn't know what time-zone you are in, or what your local legislature
> has done vis-a-vis arbitrary and cabritious adjustments to the
> start/stop date of daylight savings time, etc.
>
> It's easy enough to decode it using perl:
>
>    perl -e '$t = localtime(1289053677); print "$t\n"'

The "date" program can decode these values too:
        date -d @1289053677
-- 
Ben Pfaff 
http://benpfaff.org
