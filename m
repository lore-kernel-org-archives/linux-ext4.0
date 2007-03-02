From: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 2 Mar 2007 07:29:23 -0800
Message-ID: <a36005b50703020729m75ad7581lb75701ae121462d9@mail.gmail.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com>
	 <45E7BE4B.5070602@us.ibm.com>
	 <20070301221652.2aa3e973.akpm@linux-foundation.org>
	 <1172841831.7992.14.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Badari Pulavarty" <pbadari@us.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:42588 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992517AbXCBP30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 10:29:26 -0500
Received: by ik-out-1112.google.com with SMTP id c21so524176ika
        for <linux-ext4@vger.kernel.org>; Fri, 02 Mar 2007 07:29:25 -0800 (PST)
In-Reply-To: <1172841831.7992.14.camel@kleikamp.austin.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/2/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> Then there's no need for sys_allocate to return a long.

Every syscall must return a long.  Otherwise you can have problems on
64-bit archs.
