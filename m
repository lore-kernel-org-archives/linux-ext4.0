From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: ext2/3/4: punch support?
Date: Mon, 28 Feb 2011 17:59:30 -0700
Message-ID: <4D6C44F2.9050800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Young <hidave.darkstar@gmail.com>, josef@redhat.com,
	linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

I've actually already started on a patch set for punch hole support in ext4.  I've sent them out on the ltc-fsdev mailing list for review.  I had planned to spend another week or two running it through some more debug cases before sending it to the ext4 mailing list though.

Allison Henderson

linux-ext4-owner@vger.kernel.org wrote on 02/28/2011 06:11:18 AM:

> Josef Bacik <josef@redhat.com> 
> Sent by: linux-ext4-owner@vger.kernel.org
> 
> 02/28/2011 06:11 AM
> 
> To
> 
> Dave Young <hidave.darkstar@gmail.com>
> 
> cc
> 
> josef@redhat.com, Theodore Tso <tytso@mit.edu>, linux-
> ext4@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> 
> Subject
> 
> Re: ext2/3/4: punch support?
> 
> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
> > Hi, josef and ext guys
> > 
> > Do you have any plan with ext4 hole punching support? And the
> > fallocate for ext2/3?
> > 
> > What's the obstacle to work on this? could someone tell the status of
> > this issue?
> 
> There is no obstacle, just nobody has bothered to do it.  If you want to do it
> go for it.  Thanks,
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
