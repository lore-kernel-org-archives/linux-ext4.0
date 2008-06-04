From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 2/5] jbd: ordered data integrity fix
Date: Wed, 04 Jun 2008 19:55:22 +0900
Message-ID: <4846749A.3040206@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CF30.9050801@hitachi.com>
    <20080603153304.741eaa2b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53109 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYFDKz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 06:55:29 -0400
In-Reply-To: <20080603153304.741eaa2b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Andrew Morton wrote:

> On Mon, 02 Jun 2008 19:45:04 +0900
> Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>In ordered mode, if a buffer being dirtied exists in the committing
> 
> I changed this text to read "if a file data buffer being dirtied". 
> Please do be careful when describing all these buffers, else it gets
> more confusing that it already is.
 
Sorry for my misleading description.  I'll be careful hereafter. 

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

