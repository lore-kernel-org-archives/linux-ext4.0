From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: (unknown)
Date: Tue,  3 May 2011 16:08:36 +0300
Message-ID: <1304428117-6195-1-git-send-email-surbhi.palande@canonical.com>
References: <4DBFE09E.5070805@canonical.com>
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:38734 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ECNIt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 09:08:49 -0400
Subject: 
In-Reply-To: <4DBFE09E.5070805@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On munmap() zap_pte_range() is called which dirties the PTE dirty pages as
Toshiyuki pointed out.

zap_pte_range()
  mapping->a_ops->set_page_dirty (= ext4_journalled_set_page_dirty)  

So, I think that it is here that we should do the checking for a ext4 F.S
frozen state and also prevent a parallel ext4 F.S freeze from happening.

Attaching a patch for initial review. Please do let me know your thoughts! 

Thanks a lot!

Warm Regards,
Surbhi.


