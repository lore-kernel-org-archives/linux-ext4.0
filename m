From: Li Xi <pkuelelixi@gmail.com>
Subject: Directory/Project quota supports
Date: Wed, 15 Jan 2014 15:57:11 +0800
Message-ID: <CAPTn0cCYPQ2JhDbU+859pNSZx4__UMzFE6GvwzWbWcaNZumEWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34013 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaAOH5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jan 2014 02:57:11 -0500
Received: by mail-ie0-f180.google.com with SMTP id ar20so1663804iec.25
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jan 2014 23:57:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Currently, our team is trying to add directory/project quota support
to Lustre file system. Since ext4 is the basis of Lustre, as a part of
the project, we are also attempting to add directory/project quota to
ext4. We've made some progress, and I think it might be better to
share our work in the community before going further.

There are already some patches from Dmitry Monakhov, so we started
from his patches. We had back-ported the patches to Linux-2.6.32 (RHEL
6.x) kernel and confirmed that his patches works well generally,
though, as already discussed in this mail list, there might be some
improvements we will have to do, including eliminating the differences
with XFS project quotas.

Another thing we did is adding subtree support to quota-tools. And
with these changes, we tested subtree kernel patches. Sharing the same
userspace quota API with XFS might be a good idea, but I think it will
be strange to users if quota-tools doesn't have native support for
directory/project quota support. So keeping quota-tools updated seems
another necessary part of the project.

We are currently working on adding support to e2fsprogs. No matter
what features directory/project quota will have, e2fsprogs will have
to be updated anyway.

There might be some different opinions about how to design and
implement this new feature in detail. But it is true for sure that we
like and want this new feature. We hope our effort can do some help
more or less, and we are willing to cooperate with anybody who are
interested in this probject. It will be really helpful too if you can
give us some advices.

Thanks,
Li Xi
