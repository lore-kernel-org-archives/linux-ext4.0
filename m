From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 0/4] quota: add project quota support
Date: Fri, 1 Aug 2014 09:05:23 +0800
Message-ID: <CAPTn0cBJMx=s5YhKPEVgGa4xvxP1H9L=gJaK1iP4dkooHzr_FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:52738 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaHABFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:05:24 -0400
Received: by mail-ig0-f182.google.com with SMTP id c1so649990igq.3
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 18:05:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches propose an implementation of project support
for ext4. A project is an aggregate of unrelated inodes which might
scatter in different directories. Inodes belongs to a project
possesses a same identification i.e. 'project ID', just like every
inode has its user/group indentification. The following patches adds
project quota as supplement to the former uer/group quota types.
This project ID of an inode is iherited from its parent direcotry
and saved as an internal field of ext4 inode.

This is not the first existed attepmtion to add project quta support
for ext4. Patches of subtree quota support which was posted by Dmity
Monakhov in 2012 (http://lwn.net/Articles/506064/) implemented the
similar feature in a different way. Rather than saving the project
(or subtree) ID as an internal inode field, those patches manages
the ID as extented attributes.

We rebased both patch sets onto the same kernel version and run
benchmakrs respectively to comparing the peformance difference.
It is worth noting that patches from Lai Siyao and Niu Yawei
(quota: remove dqptr_sem,
http://article.gmane.org/gmane.comp.file-systems.ext4/44341/)
improve the performance of quota enforcement significantly, which
can be seen clearly from following results.

It is obvious that extended attribute implementation has performance
impact when creating files. That is why we choose to push the patches
which use internal inode field to save project ID.

Kernel: 3.16.0-rc5
Server: Dell R620 (2 x E5-2667@3.3GHz, 256GB memory)
Storage: 10 x 15K SAS disks(RAID10)
Test tool: mdtest-1.9.3. Mdtest created 800K files in total. Each
thread created files in unique directory.

File Creation:
                     1thr     2thr     4thr     8thr    16thr
- vanilla
quota disabled      66094   105781   178968   186647   172536
quotaon(ug)         60337    99582   157396   171463   162872

- vanilla + remove-dqptr_sem patches
quota disabled      65955   112082   185550   181511   171988
quotaon(ug)         62391   101905   171013   190570   168914

- prjquota(xattr)
quota disabled      61396    97580   147852   146423   164895
quotaon(ug)         57009    93435   140589   135748   153196
quotaon(ugP)        57500    89419   133604   125291   105127

- prjquota(xattr) + remove-dqptr_sem patches
quota disabled      64053   100078   147608   139403   163960
quotaon(ug)         60754   104726   149231   139053   165990
quotaon(ugP)        59238    93606   148921   138434   163931

- prjquota(internal) + remove-dqptr_sem patches
quota disabled      65826   111828   181486   189227   171241
quotaon(ug)         65418   107745   173584   180562   173752
quotaon(ugP)        64669   103890   169176   186426   172192


File Removal:
                     1thr     2thr     4thr     8thr    16thr
- vanilla
quota disabled     118059   169825   234661   291812   345656
quotaon(ug)        106675   135834   153532   100437    87489

- vanilla + remove-dqptr_sem patches
quota disabled     120374   168437   236818   291754   331141
quotaon(ug)        110709   161954   238333   293700   329015

- prjquota(xattr)
quota disabled     116680   161662   229190   295642   332959
quotaon(ug)        104783   134359   154950   100516    87923
quotaon(ugP)       100240   125978   108653    68286    58991

- prjquota(xattr) + remove-dqptr_sem patches
quota disabled     116281   168938   233733   286663   344002
quotaon(ug)        109775   164995   236001   299389   340683
quotaon(ugP)       113935   162979   236112   300033   356117

- prjquota(internal) + remove-dqptr_sem patches
quota disabled     119537   171565   247418   291068   350138
quotaon(ug)        121756   159580   240778   298012   342437
quotaon(ugP)       118954   168022   241206   289055   334008
