From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Tue, 11 Sep 2012 13:16:39 -0500
Message-ID: <504F8007.7070208@redhat.com>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com> <20120910024709.GA3439@thunk.org> <CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com> <CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com> <CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com> <CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com> <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com> <20120911170041.GB763@thunk.org> <CAHSRzpCFs1GdcMkNcXpoN0Q5MnGwQuonETTv8k9kELZwSe=sWw@mail.gmail.com> <20120911180646.GC763@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Terry <td3201@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2IKSQn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 14:16:43 -0400
In-Reply-To: <20120911180646.GC763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/11/12 1:06 PM, Theodore Ts'o wrote:
> On Tue, Sep 11, 2012 at 12:07:14PM -0500, Terry wrote:
>>
>> RHEL 6.3 with kernel 2.6.32-279.5.2.el6.x86_64
> 
> I'll let Eric or Lukas comment, but as far as I know the ext4 in the
> RHEL 6 kernels has been quite stable (there are a lot of bug fixes
> that have been backported to the RHEL 6 kernel, and while it doesn't
> have some of the newer ext4 features, it doesn't have any of the more
> exciting bugs that might come with the newer features :-).
> 
> So I really would strongly suspect the SAN or the SAN-attached storage
> as being flaky, causing the file system corruptions which is leading
> to the kernel and e2fsck complaining.

Right, ext4 is default in RHEL6 and well tended.  We'll let support look
at the case, and see what's going on.  But I'd certainly troubleshoot
the san as well, esp. to be sure HA is set up properly and not mounting
it twice on 2 nodes etc.

-Eric


> Regards,
> 
> 						- Ted
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

