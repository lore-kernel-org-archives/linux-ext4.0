From: Andreas Dilger <adilger@sun.com>
Subject: test for EA validity checking
Date: Sat, 10 Nov 2007 05:10:11 -0700
Message-ID: <20071110121011.GA14858@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:42332 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXKJMKO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Nov 2007 07:10:14 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attached is a test image for extended attribute block checking.
This small image contains a number of different kinds of corruptions
(bad magic, bad checksum, empty block, bad EA block number), as well
as an old-format (v1) EA, and a valid v2 EA.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--uAKRQypu60I7Lcqm
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="f_ea_checks.tgz"
Content-Transfer-Encoding: base64

H4sIAPqeNUcAA+2Ya3ATVRTHQ4tDCWjkMShIyXUqmEKa7m52k7Y8An1hWyptqhaspbNNNsm2
yQZ2N7SpQOSD1Mc4w0PsgJYqDvKKqFVEyiOMQwBlaNDBMgWRAaTFYiuMfUA7adwkRVYItsy0
dJT9fchuds89/3P3nLv3JIYCAi/QmQhdMRMrGiAgDrUa8x9hNQbxj7cQwZAaxpSwWomqRBCs
hCFYBLCBCoiPjWFxGgARrifNRoK+p11v9/+jGHj5J0oXEzpWAfe3hj/BKhV6r/wjMIbeyr9K
qYS5/KMoVwYA6u9AQvGQ5z8LZxgAJ4AkfwmQlBGQlFVPMHJQaLZyNSEHOKUHDFlGMOIUmrbS
gCa4J8HZEaUsQekJPcBZliYLbSwRHAIQFTBwdgE/AFYqAEgyEzitAXbOhzit57IckAVBCUAy
AJEDxmS1mfWgkAAQNySVLO0ZkHK3Dknd8o4CE84A3P9pAjJYhcYrUQiOi48GJSZSZ/K7Jqml
uJnUi0MEgfY9iD5OPY4/dXXoqav7XTWer6q6Q7WPTjCM7wQJHTrS59ADZYXwykpP0ty7xUrb
AcPSNh1ro4lQqQ0Gw4sEA7JYA05H81IJZPHx8dGKf2Q0oKcMqaezUhR3Si4lWXvQDuXZ0YSB
oAlKR3B2NoplghYYz8JIW22LAWOzWHDOG0lxwVlwlrRS4sRAsIUka8EXc4KGHk9MAgAxMkQV
E4NwhRiDYeLbzyWVJnomyQQFQQlt5UT8Mw4KRUFAhsbB8uBtQj8TjVNxk+3dxb+PErMEwxYY
SDPB2LkAp/oBqWnzUkDOwpwXUjJB7pwckDk/OS01LSU5ePuOIbA6VoWCwFcggxTQZEBZqRju
6bKk0Wa1MdFybunHYjDSExyXXpLlso2ztkC1wOLBftcJ3A1//6dwCzEQGr3s/xCE/t3/qTAI
9fd/aq4NEPb/B8A9N4RgTQhr9n9OiP4f6W+N3tY/imBC/z9I3Ef/36eeblAasf5tVKCH6aXH
X/+kBTcSCmNZf2v09vsfUqG3//+BMP/6xxBEWP8PAunbERHuTdjcsPBA9kXN5zwZY/Enh13b
sPD1Y+k7T3w/enrqmvTPT03WRlRs289K3m19vC6xaOWz+8YlJ2ftUVTWsNtH1rC/abMruodI
Rg29uCWJrf9lg43omlPkfK+5Mbygg+iIlBqubajanD0U3XGwNUM73nMk+9SYRZfODO+amtaY
HzltbMEi+dj3Ny9jl86qbXBHvV6IxlVkfqo4PRqJrHZcyNv6h2fZzOut5349dNaoTkj3WCtr
utR1be1dSflPTapqWd7acGHv1eby6Ws3eqrbFjzyhRTuxveu/mR1g9P36ubDU1auylZU7BtX
G9Z9mB2/4OjFphUiE7T7tOsn5+WbR19xXA7Tlzmz9n+5uml9WvPuY4atRbMrDzzXoTngOuOb
/MOujfa8xJeTziR+vco8on7SWkn9qB8nVSufyTd0iJs037xkP1Fe4336prtzybkW90RNO95w
DGmSOLXeg1ku3fi2+bu03u4sh2d02/EnxO6ipuWN7VdW7uqSMq7PHMqJHTu2l3hz59NRlRlO
R9nPld6WG3muZl/CqfPFueGB7BRPOXDUFf3Wuhb3krVsSe6Kco3UMu9I+qUxw+ZmrKuo3Vq1
5Tv3x1u07TNmRUok+bWb3nnxSE69str8fKnLsmTG+pnKfRUjmG+rD7k+ulze7ftgZ6vmJNho
Djvpe617WKvmQ98Qr+SKY7YvvFMauFRXfiOn3TEjMaHRM9L7VfEbLr1jr9N+4c8311wffnZk
3Z5pSbp1UfWyhXN8kseuOm5UdZ6/Lp2wx5d3vFM6YbdvyCCXssBAsq3tUW3m7xEiUcRgRyIg
ICAgICAgICAgICAgIHCf/AVg5f84ACgAAA==

--uAKRQypu60I7Lcqm--
