From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] cleanup duplicates in all tests
Date: Thu, 4 Apr 2013 06:59:56 -0500
Message-ID: <515D6B3C.5070104@sgi.com>
References: <20130403173245.376605011@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
To: <xfs@oss.sgi.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20130403173245.376605011@sgi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks for the review Eric, this patch has been committed.

--Rich

commit 0efd4f4d483a725212f531bc2ed964de2766b1cd
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Wed Apr 3 17:31:49 2013 +0000

     xfstests: cleanup duplicates in all tests

     There are duplicate blank lines, comment hash and lines
     containing duplicate seqres= declarations, remove them.
