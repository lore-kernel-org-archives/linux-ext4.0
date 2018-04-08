From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: WARNING in ext4_superblock_csum_set
Date: Sat, 7 Apr 2018 22:40:20 -0400
Message-ID: <20180408024020.GA9720@thunk.org>
References: <001a113ec036ea84f90568e088dc@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+f3b1a2c79758f3eec76c@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a113ec036ea84f90568e088dc@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

#syz fix: ext4: always initialize the crc32c checksum driver
