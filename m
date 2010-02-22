From: Andreas Dilger <adilger@sun.com>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has	been
 remounted readonly
Date: Mon, 22 Feb 2010 16:09:17 -0700
Message-ID: <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
 <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
 <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Camille Moncelier <pix@devlife.org>, linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-02-22, at 16:05, Jan Kara wrote:
>  Hmm, and apparently there is some subtlety in the loopback device  
> code because even when I use sync(1), the first and second images  
> sometimes differ (although it's much rarer). But I see a commit  
> block of the transaction  already in the first image (the commit  
> block is written last) but the contents of the transaction is  
> present only in the second image.


It has never been safe to run ext3 on top of a loop device, because  
the loop device does not preserve ordering, and I'm not sure whether  
it properly passes barriers either.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

