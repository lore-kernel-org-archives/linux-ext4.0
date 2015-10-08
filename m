From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Hard lockup in ext4_finish_bio
Date: Thu, 8 Oct 2015 17:37:07 +0300
Message-ID: <56167F93.8010408@kyup.com>
References: <56165784.60206@kyup.com>
 <22038.32498.570540.37956@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
	Jan Kara <jack@suse.com>
To: John Stoffel <john@stoffel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22038.32498.570540.37956@quad.stoffel.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 10/08/2015 05:34 PM, John Stoffel wrote:
> Great bug report, but you're missing the info on which kernel you're

This is on 3.12.47 (self compiled). It was evident on my initial post,
but I did forget to mention that in the reply. Also, I suspect even
current kernel are susceptible to this since the locking in question
hasn't changed.

Regards,
Nikolay
