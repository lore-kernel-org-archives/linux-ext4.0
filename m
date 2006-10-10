From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: ext3 fsx failures on 2.6.19-rc1
Date: Tue, 10 Oct 2006 11:49:23 -0500
Message-ID: <452BCF13.6070200@redhat.com>
References: <1160436605.17103.27.camel@dyn9047017100.beaverton.ibm.com>	 <20061010123059.GJ23622@atrey.karlin.mff.cuni.cz> <1160498487.17103.30.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, akpm@osdl.org,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52380 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1030203AbWJJQtb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 12:49:31 -0400
To: Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <1160498487.17103.30.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
						
> fsx got a segmentation fault and died. These are the messages in the
> dmesg.

I've never seen fsx die that way before... can you get a coredump to see
where it was at?

-Eric
