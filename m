From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: another ext3 kernel BUG
Date: Mon, 13 Jun 2011 22:32:20 -0500
Message-ID: <4DF6D644.3010109@redhat.com>
References: <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>,
	Norbert Preining <preining@logic.at>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1FNDca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 23:32:30 -0400
In-Reply-To: <20110614032111.GA5392@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/13/11 10:21 PM, Dave Jones wrote:
> On Tue, Jun 14, 2011 at 11:43:07AM +0900, Norbert Preining wrote:
>  
>  > > You seem uniquely able to hit it, and you do have a truckload of interesting modules loaded.  :)
>  > 
>  > Interesting modules?
>  > alsa stuff, bluetooth, fuse/fat/vfat for ntfs/external drives, wlan
>  > the only thing that stand out is the vbox* I guess, all the others are
>  > pretty standard, aren't they?
> 
> we've been getting a lot of bug reports in Fedora that have the vbox module
> loaded that manifest in various ways that look like it's corrupting kernel data
> structures. (Usually it scribbles over some linked list, and the CONFIG_LIST_DEBUG
> stuff catches it).
> 
> I'd definitly try and reproduce it without that having been loaded if you can.
> 
> 	Dave

Yep, that's what I thought was "interesting" :)

-Eric
