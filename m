From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] ext4: Avoid transaction stalls during writeback
Date: Tue, 11 Apr 2017 15:54:15 +0200
Message-ID: <20170411135418.9638-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752410AbdDKNy0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Apr 2017 09:54:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this series fixes stalls I've observed during a workload simulating Postgress
database. The series reduces transaction commit times about 100x in my test
setup. See patch 3/3 for more details about the workload and the results.
The series has passed testing with xfstests with 4k and 1k blocksize and
a test with 4k blocksize in dioreadnolock mode.

								Honza
