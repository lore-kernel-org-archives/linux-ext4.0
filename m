From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Mon, 30 Apr 2007 16:36:13 +0530
Message-ID: <cc723f590704300406l5c3a8a84y2cd3aecd52209c2b@mail.gmail.com>
References: <462D42CA.50509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Avantika Mathur" <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:13365 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXD3LGO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2007 07:06:14 -0400
Received: by nz-out-0506.google.com with SMTP id o1so1877068nzf
        for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2007 04:06:14 -0700 (PDT)
In-Reply-To: <462D42CA.50509@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/24/07, Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:
> Ext4 Developer Interlock Call: 04/23/2007 Meeting Minutes
>
> TESTING
> - extents testing
>     - Discussed methods for testing extents on highly fragmented
> filesystems.
>     - Jose will look into possible tests, including perhaps using the
> 'aged' option in FFSB
>     - Ted suggested creating a mountoption that creates a bad block
> allocator which it jumps to a new block group every 8 blocks.  This
> would force a very large number of extents, and may be a good test for
> extents.


What i am doing for creating a large number of extents is

dd if=/dev/zero of=myfile count=10
seek=20
while [ 1 ]; do dd if=/dev/zero of=myfile count=10 seek=$seek;
seek=`expr $seek + 20`; done


-aneesh
