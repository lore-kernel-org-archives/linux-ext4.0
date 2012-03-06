From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Mon, 05 Mar 2012 20:26:03 -0800
Message-ID: <4F5591DB.4060807@oracle.com>
References: <20120305125029.GA5121@gmail.com> <4F55189B.4080507@oracle.com> <20120306023505.GA7728@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36008 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab2CFE0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 23:26:10 -0500
In-Reply-To: <20120306023505.GA7728@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/5/2012 6:35 PM, Zheng Liu wrote:
> No, _RANDOM means that file system doesn't need to try its best to find
> a proper position to allocate some blocks for this file.  Furthermore,
> currently random IOs seem that they are not obviously slower than
> sequential IOs in Flash/SSD device.  For example, when users know a file
> that is accessed infrequently, they can put this file in a corner, such
> as in some discontinuously blocks.  Then sequential blocks are reserved
> for the file that needs to be accessed frequently and users can obtain
> the better performance.

Then FADV_ALLOC_HOT_REGION and FADV_ALLOC_COLD_REGION are
probably better terms.

