From: Asdo <asdo@shiftmail.org>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 08 Jun 2012 15:57:04 +0200
Message-ID: <4FD204B0.3000204@shiftmail.org>
References: <4FD1CB8A.9080805@shiftmail.org>
 <20120608223332.5fe49193@notabene.brown> <4FD202CD.7000309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4FD202CD.7000309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/08/12 15:49, Phil Turmel wrote:
>
> To put it another way:  You can't safely access ext filesystems via
> raw devices in two systems.  The kernel cache won't be synchronized,
> and you almost certainly *will* corrupt the contents.

Thanks both of you for your explanations

I might say that it seems to me a bad design: never before I saw a cache 
that is not updated by writes.
Here the cache content is *older* than the data on the real devices!?
if it was *newer*, there are known cases (writeback cache not flushed 
yet), but *older*... never seen.

Thanks
