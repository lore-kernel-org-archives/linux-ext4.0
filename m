From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Bio: Determining encrypted vs plain content
Date: Wed, 13 Sep 2017 15:33:33 +0530
Message-ID: <2507710.a1WupZru2S@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Michael Halcrow <mhalcrow@google.com>,
        linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38081 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751541AbdIMKC4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Sep 2017 06:02:56 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DA1A2h056899
        for <linux-ext4@vger.kernel.org>; Wed, 13 Sep 2017 06:02:56 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cy24ch7d8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 13 Sep 2017 06:02:55 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 13 Sep 2017 20:02:52 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am trying to get encryption to work on block size < page size scenario
(e.g. 4k block size on ppc64's 64k page size).

One of the last scenarios that I am working on is to decrypt a page whose
blocks are not contiguously stored on the underlying disk. 

The code assumes that bio's pages are supposed to be decrypted if 
bio-b_private has a non-zero value (See the definition of 
ext4_bio_encrypted()).

Instead of that, why can't the code extract the first page from the first bio
vector of the bio and then use ext4_encrypted_inode(page->mapping->host) to
determine if bio's pages are supposed to contain encrypted data? Was there a
specific reason to not use ext4_encrypted_inode()?

-- 
chandan
