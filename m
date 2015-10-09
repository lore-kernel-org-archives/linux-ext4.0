From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Hard lockup in ext4_finish_bio
Date: Fri, 9 Oct 2015 11:05:10 +0300
Message-ID: <56177536.10501@kyup.com>
References: <56165784.60206@kyup.com>
 <22038.32498.570540.37956@quad.stoffel.home> <56167F93.8010408@kyup.com>
 <22038.48242.126925.476449@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
	Jan Kara <jack@suse.com>
To: John Stoffel <john@stoffel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22038.48242.126925.476449@quad.stoffel.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 10/08/2015 09:56 PM, John Stoffel wrote:
>>>>>> "Nikolay" == Nikolay Borisov <kernel@kyup.com> writes:
> 
> Nikolay> On 10/08/2015 05:34 PM, John Stoffel wrote:
>>> Great bug report, but you're missing the info on which kernel
>>> you're
> 
> Nikolay> This is on 3.12.47 (self compiled). It was evident on my
> Nikolay> initial post, but I did forget to mention that in the
> Nikolay> reply. Also, I suspect even current kernel are susceptible to
> Nikolay> this since the locking in question hasn't changed.
> 
> Hi Nikolay, must have missed it.  I looked quickly, but didn't find
> it.  Since it's such an older kernel release, it might be best if you
> upgrade to the latest version and try to re-create the lock if at all
> possible.  

The relevant code hasn't changed. I've already posted RFC patches. You
can find the thread here: http://thread.gmane.org/gmane.linux.kernel/2056996

> 
> What kind of workload are you running on there?  And if you have more
> details on the hardware, that might help as well.  
> 
> John
> 
