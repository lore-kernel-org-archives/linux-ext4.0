From: Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 0/3] ext4: fix spectre v1 gadgets
Date: Fri, 27 Jul 2018 16:23:54 +0000
Message-ID: <20180727162357.30801-1-jcline@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Cline <jcline@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks,

This patch set fixes a few Spectre v1 gadgets in ext4 detected with the
help of Smatch.

Note that because the speculation window is large, the policy is to stop
the speculative out-of-bounds load and not worry if the attack can be
completed with a dependent load or store[0].

[0] https://marc.info/?l=linux-kernel&m=152449131114778

Jeremy Cline (3):
  ext4: super: Fix spectre gadget in ext4_quota_on
  ext4: super: Fix spectre gadgets in ext4_quota_{read,write,off}
  ext4: mballoc: Fix spectre gadget in ext4_mb_simple_scan_group

 fs/ext4/mballoc.c |  2 ++
 fs/ext4/super.c   | 20 ++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.17.1
