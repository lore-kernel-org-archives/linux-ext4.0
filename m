From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: JBD commmit : Get list of all 'to be written' buffers in advance
Date: Thu, 12 May 2011 19:52:21 +0530
Message-ID: <4DCBED1D.2010109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:47045 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1ELOX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 10:23:59 -0400
Received: by pxi16 with SMTP id 16so1035165pxi.4
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 07:23:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
          I am trying to implement a concept called Transactional Flash 
(http://www.usenix.org/event/osdi08/tech/full_papers/prabhakaran/prabhakaran_html/) 

          in which all writes are flushed to disk (in this case Flash) 
as a circular linked list of pages. No journaling mechanisms are used.
           For that I am trying to get list of all buffers to be written 
(metadata or data) before actually writing them. I thought of 2 
approaches :

1. Get conservative list of all buffers before flushing any of them 
(before commit phase 2) in journal_commit_transaction function.
      Problem : Metadata writes use temporary buffers which are 
allocated just before write.

2. Instead of submitting buffers straightaway, collect all of them ( 
data + metadata ) and flush them in end.
      Problem :  i.   Possibility of blocking after data buffers are  
collected but before metadata buffer collection.
                            Since data buffers are locked, this may lead 
to deadlock. (I am not sure if it is spinlock)

                       ii.   Not able to differentiate between metadata 
buffers and Descriptor buffers.


Can anybody please help me in this regard?

Niraj
