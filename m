From: Chris J Arges <chris.j.arges@canonical.com>
Subject: [3.17.y-3.19.y][cherry-pick] ext4: fix indirect punch hole corruption
Date: Fri, 20 Mar 2015 11:05:01 -0500
Message-ID: <550C452D.4030806@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Please include the following commit into 3.17.y, 3.18.y, and 3.19.y
stable trees.
commit 6f30b7e37a8239f9d27db626a1d3427bc7951908
Author: Omar Sandoval <osandov@osandov.com>
Date:   Sat Feb 14 20:08:51 2015 -0500

    ext4: fix indirect punch hole corruption

Fixes: 4f579ae7de560e5f449587a6c3f02594d53d4d51

This bug fixes several corner case bugs related to hole punching on EXT
file systems that use indirect mapping. One case was reproduced here,
and I've tested with this patch and it resolves the issue:
http://bugs.launchpad.net/bugs/1292234

I've also been able to cherry-pick these cleanly into the aforementioned
trees and they build. I've only tested on 3.19. I believe Omar may have
additional test cases.

Thanks,
--chris j arges
