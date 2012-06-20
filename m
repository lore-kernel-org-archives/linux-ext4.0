From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 14:18:44 +0900
Message-ID: <20120620051844.GA7829@gamma.logic.tuwien.ac.at>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:43877 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2FTFSt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 01:18:49 -0400
Content-Disposition: inline
In-Reply-To: <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On Di, 19 Jun 2012, Eric Sandeen wrote:
> blktrace of the actions would show you something interesting as well.

I tried to understand the output, but didn't get any information
that tells me something.

I rebooted into single user mode, started blktrace on sda, then run
time ls -l /..../dir/with/links/ >/dev/null, stopped the blktrace.

Then I run blkparse and btt etc to generate a variety of data.
Here are some output of the btt run:
==================== All Devices ====================

            ALL           MIN           AVG           MAX           N
--------------- ------------- ------------- ------------- -----------

Q2Q               0.000002654   0.009716548   6.594440648        8953
Q2G               0.000001047   0.000001825   0.000011594        8913
G2I               0.000000908   0.000001561   0.000234317        8913
Q2M               0.000000908   0.000001046   0.000001536          41
I2D               0.000005378   0.001040528   1.572900300        8913
M2D               0.000014527   0.038626776   1.572908333          41
D2C               0.000098337   0.009050273   0.053790446        8954
Q2C               0.000108394   0.010266282   1.577191424        8954

==================== Device Overhead ====================

       DEV |       Q2G       G2I       Q2M       I2D       D2C
---------- | --------- --------- --------- --------- ---------
 (  8,  0) |   0.0177%   0.0151%   0.0000%  10.0890%  88.1553%
---------- | --------- --------- --------- --------- ---------
   Overall |   0.0177%   0.0151%   0.0000%  10.0890%  88.1553%

==================== Device Merge Information ====================

       DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
---------- | -------- -------- ------- | -------- -------- -------- --------
 (  8,  0) |     8954     8913     1.0 |        8        9     1024    86872

==================== Device Q2Q Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8,  0) |            8954     193362127.3               0 | 0(538)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |            8954     193362127.3               0 | 0(538)

==================== Device D2D Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8,  0) |            8913     194044831.4               0 | 0(497)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |            8913     194044831.4               0 | 0(497)

==================== Plug Information ====================

       DEV |    # Plugs # Timer Us  | % Time Q Plugged
---------- | ---------- ----------  | ----------------
 (  8,  0) |         81(         0) |   0.002663579%

       DEV |    IOs/Unp   IOs/Unp(to)
---------- | ----------   ----------
 (  8,  0) |        1.2          0.0
---------- | ----------   ----------
   Overall |    IOs/Unp   IOs/Unp(to)
   Average |        1.2          0.0

==================== Active Requests At Q Information ====================

       DEV |  Avg Reqs @ Q
---------- | -------------
 (  8,  0) |           0.1

.....


I don't know if that shows anything of interest, but if you need more,
and want to waste a bit of time looking at the data, I have uploaded
everything created into
	http://www.logic.at/people/preining/BlkParse.tar.gz
size 5090853
md5sum 46db8455a04dcc4a602e34d21eecc6bd

In any case, thanks for your patience and support

Norbert

------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
KIRBY (n.)
Small but repulsive piece of food prominently attached to a person's
face or clothing. See also CHIPPING ONGAR.
			--- Douglas Adams, The Meaning of Liff
