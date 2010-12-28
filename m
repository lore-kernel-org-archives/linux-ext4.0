From: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 09:32:55 -0500
Message-ID: <20101228143255.GI10149@thunk.org>
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
 <4D19BEF1.9010708@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Con Kolivas <kernel-S9WDWIYMKk5AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torn5 <torn5-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D19BEF1.9010708-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 28, 2010 at 11:41:53AM +0100, torn5 wrote:
> 
> This is going to be a faq...
> I suppose the datetime is encoded (what format is that?) in that
> long number after "at".

Number of seconds since January 1st, 1970 midnight GMT.  (Standard
Unix-time format).  It's hard for the kernel to decode it since it
doesn't know what time-zone you are in, or what your local legislature
has done vis-a-vis arbitrary and cabritious adjustments to the
start/stop date of daylight savings time, etc.

It's easy enough to decode it using perl:

   perl -e '$t = localtime(1289053677); print "$t\n"'

> May I suggest the datetime gets decoded in the printing?
> Also may I suggest that the error happens immediately after mount
> and not after 300 seconds from mount?

Hmmm.... maybe.  The idea behind the 300 second delay was for the root
file system, to let e2fsck have a chance to fix the file system before
reporting the errors at mount time.

						- Ted


     	     	       
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
