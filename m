From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] fs-ext4: Adjustments for two function implementations
Date: Sat, 19 Aug 2017 13:46:23 +0200
Message-ID: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 19 Aug 2017 13:35:43 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in ext4_multi_mount_protect()
  Improve a size determination in two functions

 fs/ext4/dir.c | 2 +-
 fs/ext4/mmp.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.14.0
