From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 0/8] Ext4 encryption support for blocksize < pagesize
Date: Fri, 12 Jan 2018 11:07:59 -0800
Message-ID: <1aa4981a-63ef-aaa4-97da-9c9137d52862@infradead.org>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56018 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964998AbeALTIB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 14:08:01 -0500
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/18 06:11, Chandan Rajendra wrote:
> This patchset implements code to support encryption of Ext4 filesystem
> instances that have blocksize less than pagesize. The patchset has
> been tested on both ppc64 and x86_64 machines.

strictly "less than" or "less than or equal to"?

thanks,
-- 
~Randy
