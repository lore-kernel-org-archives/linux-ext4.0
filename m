From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 0/2] ext4: ext4_mb_normalize_request() fixes
Date: Mon,  3 Mar 2014 15:00:26 +0100
Message-ID: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

The first patch fixes an incorrect assert in ext4_mb_normalize_request();
the second patch fixes a kernel panic occurring when using a filesystem
with a low number of blocks per group.


Maurizio Lombardi (2):
  ext4: fix wrong assert in ext4_mb_normalize_request()
  ext4: fix bug in ext4_mb_normalize_request()

 fs/ext4/mballoc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

-- 
Maurizio Lombardi

