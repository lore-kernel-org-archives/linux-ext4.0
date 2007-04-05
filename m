From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Thu, 5 Apr 2007 17:14:16 +0530
Message-ID: <20070405114416.GB19982@amitarora.in.ibm.com>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070405112619.GA19982@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: Jakub Jelinek <jakub@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35121 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766951AbXDELoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Apr 2007 07:44:14 -0400
Content-Disposition: inline
In-Reply-To: <20070405112619.GA19982@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 05, 2007 at 04:56:19PM +0530, Amit K. Arora wrote:

Correction below:

> asmlinkage long sys_s390_fallocate(int fd, loff_t offset, loff_t len, int mode)
> {
>         return sys_fallocate(fd, offset, len, mode);
          return sys_fallocate(fd, mode, offset, len);
> }

--
Regards,
Amit Arora
