From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: Error testing ext3 on brd ramdisk
Date: Fri, 20 Mar 2009 14:49:01 +0200
Message-ID: <20090320124901.GJ21564@smart.research.nokia.com>
References: <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net> <20090317094019.GA10360@smart.research.nokia.com> <20090318121116.GC14622@wotan.suse.de> <20090318134202.GB11965@atrey.karlin.mff.cuni.cz> <20090320122405.GI21564@smart.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
	Denis Karpov <ext-denis.2.karpov@gmail.com>,
	"ext Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	"Hunter Adrian (Nokia-D/Helsink
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39874 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZCTMtw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Mar 2009 08:49:52 -0400
Content-Disposition: inline
In-Reply-To: <20090320122405.GI21564@smart.research.nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 20, 2009 at 02:24:05PM +0200, Denis Karpov wrote:
> Unfortunately it looks like the problem is not fixed - JBD still complains
> and in the end HTREE is getting damaged, in both ext3 and ext4 tests (see
> attached logs).
> 
> Denis

Please, disregard the previos message, I tested with a wrong patchset.
Sorry for the hussle.

Denis
