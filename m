From: "John Stoffel" <john@stoffel.org>
Subject: Re: Hard lockup in ext4_finish_bio
Date: Thu, 8 Oct 2015 14:56:50 -0400
Message-ID: <22038.48242.126925.476449@quad.stoffel.home>
References: <56165784.60206@kyup.com>
	<22038.32498.570540.37956@quad.stoffel.home>
	<56167F93.8010408@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: John Stoffel <john@stoffel.org>,
	"Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
	Jan Kara <jack@suse.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56167F93.8010408@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Nikolay" == Nikolay Borisov <kernel@kyup.com> writes:

Nikolay> On 10/08/2015 05:34 PM, John Stoffel wrote:
>> Great bug report, but you're missing the info on which kernel
>> you're

Nikolay> This is on 3.12.47 (self compiled). It was evident on my
Nikolay> initial post, but I did forget to mention that in the
Nikolay> reply. Also, I suspect even current kernel are susceptible to
Nikolay> this since the locking in question hasn't changed.

Hi Nikolay, must have missed it.  I looked quickly, but didn't find
it.  Since it's such an older kernel release, it might be best if you
upgrade to the latest version and try to re-create the lock if at all
possible.  

What kind of workload are you running on there?  And if you have more
details on the hardware, that might help as well.  

John
