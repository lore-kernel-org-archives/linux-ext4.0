From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 02 Mar 2007 07:23:51 -0600
Message-ID: <1172841831.7992.14.camel@kleikamp.austin.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com> <45E7BE4B.5070602@us.ibm.com>
	 <20070301221652.2aa3e973.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50773 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992425AbXCBNX6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 08:23:58 -0500
In-Reply-To: <20070301221652.2aa3e973.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amit wrote:

>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);

On Thu, 2007-03-01 at 22:16 -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 22:03:55 -0800 Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > Just curious .. What does posix_fallocate() return ?
> 
> bookmark this:
> 
> http://www.opengroup.org/onlinepubs/009695399/nfindex.html
> 
>     Upon successful completion, posix_fallocate() shall return zero;
>     otherwise, an error number shall be returned to indicate the error.

Then there's no need for sys_allocate to return a long.
-- 
David Kleikamp
IBM Linux Technology Center
