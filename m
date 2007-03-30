From: Paul Mackerras <paulus@samba.org>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 30 Mar 2007 19:15:58 +1000
Message-ID: <17932.54606.323431.491736@cargo.ozlabs.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXC3Kci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2007 06:32:38 -0400
In-Reply-To: <20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Heiko Carstens writes:

> If possible I'd prefer the six-32-bit-args approach.

It does mean extra unnecessary work for 64-bit platforms, though...

Paul.
