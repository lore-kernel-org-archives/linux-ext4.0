From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 22:16:52 -0800
Message-ID: <20070301221652.2aa3e973.akpm@linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<45E7BE4B.5070602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422948AbXCBGRv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 01:17:51 -0500
In-Reply-To: <45E7BE4B.5070602@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 01 Mar 2007 22:03:55 -0800 Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Just curious .. What does posix_fallocate() return ?

bookmark this:

http://www.opengroup.org/onlinepubs/009695399/nfindex.html

    Upon successful completion, posix_fallocate() shall return zero;
    otherwise, an error number shall be returned to indicate the error.
