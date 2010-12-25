From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Fri, 24 Dec 2010 22:15:29 -0500
Message-ID: <20101225031529.GA2595@thunk.org>
References: <1292710543.17128.14.camel@nayuki>
 <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
 <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
 <20101224085126.2a7ff187@notabene.brown>
 <20101223222206.GD12763@thunk.org>
 <4D13E98D.8070105@ontolinux.com>
 <20101224004825.GF12763@thunk.org>
 <4D13F09D.4010703@ontolinux.com>
 <20101224095105.GG12763@thunk.org>
 <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52523 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab0LYDPh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Dec 2010 22:15:37 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 24, 2010 at 12:14:21PM +0100, Olaf van der Spek wrote:
> 
> Thanks for taking the time to answer. The thread was started due to
> the dpkg issue.

I've talked to the dpkg folks and I believe they are squared away; for
their use case sync_file_range() combined with fsync() should solve
their reliability and performance problem.

						- Ted
