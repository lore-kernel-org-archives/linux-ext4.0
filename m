From: Theodore Tso <tytso@mit.edu>
Subject: Re: Some 64-bit tests
Date: Sat, 13 Jun 2009 00:24:56 -0400
Message-ID: <20090613042456.GH24336@mit.edu>
References: <18887.1244469441@gamaville.dokosmarshall.org> <20090608201037.GB23723@skywalker> <14597.1244517228@gamaville.dokosmarshall.org> <20090610181320.GA6953@mit.edu> <20090611055006.GA8073@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57049 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZFMEZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Jun 2009 00:25:03 -0400
Content-Disposition: inline
In-Reply-To: <20090611055006.GA8073@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 11, 2009 at 11:20:06AM +0530, Aneesh Kumar K.V wrote:
> 
> I already have a RFC patch which Nick actually tested. It is giving 32MB
> extents, which is expected because the max order in buddy cache is
> blocksize_bits + 1. I have a Fixme in there regarding scaling the start
> block which was hoping to fix soon.

I've dropped this into the unstable section of the ext4 patch queue
for testing purposes.  It definitely does a better job, although first
extent tends to be 8MB, and then after that things tend to be
allocated in 32MB chunks.

						- Ted

   814(f): expecting  57344 actual extent phys  73728 log 16384 len 8192
   814(f): expecting  81920 actual extent phys  90112 log 24576 len 8192
   831(f): expecting  59392 actual extent phys  65536 log 2048 len 8192
   831(f): expecting  73728 actual extent phys  81920 log 10240 len 8192
   831(f): expecting  90112 actual extent phys 106496 log 18432 len 8192
   831(f): expecting 114688 actual extent phys 131072 log 26624 len 6144
   834(f): expecting  65536 actual extent phys 114688 log 4096 len 8192
   834(f): expecting 122880 actual extent phys 155648 log 12288 len 7
   838(f): expecting 102400 actual extent phys 147456 log 2048 len 3693
   839(f): expecting 147456 actual extent phys 180224 log 8192 len 8192
   839(f): expecting 188416 actual extent phys 196608 log 16384 len 2791
   849(f): expecting 155648 actual extent phys 188416 log 4096 len 8192
   849(f): expecting 196608 actual extent phys 204800 log 12288 len 8192
   849(f): expecting 212992 actual extent phys 221184 log 20480 len 8192
   849(f): expecting 229376 actual extent phys 245760 log 28672 len 4096
   850(f): expecting 131072 actual extent phys 212992 log 2048 len 8192
   850(f): expecting 221184 actual extent phys 237568 log 10240 len 8192
   850(f): expecting 245760 actual extent phys 253952 log 18432 len 8192
   850(f): expecting 262144 actual extent phys 270336 log 26624 len 6144
  1080(f): expecting 172032 actual extent phys 262144 log 4096 len 8192
  1080(f): expecting 270336 actual extent phys 286720 log 12288 len 8192
  1080(f): expecting 294912 actual extent phys 303104 log 20480 len 32768
  1080(f): expecting 344064 actual extent phys 352256 log 61440 len 8192
  1080(f): expecting 360448 actual extent phys 368640 log 69632 len 8192
  1080(f): expecting 376832 actual extent phys 385024 log 77824 len 4007
  1082(f): expecting 237568 actual extent phys 360448 log 4096 len 8192
  1082(f): expecting 368640 actual extent phys 376832 log 12288 len 8192
  1082(f): expecting 385024 actual extent phys 425984 log 20480 len 3966
 16386(d): expecting   9259 actual extent phys   9299 log 1 len 2
 26715(f): expecting 696320 actual extent phys 712704 log 8192 len 8192
 26715(f): expecting 720896 actual extent phys 745472 log 16384 len 2240
 26716(f): expecting 700416 actual extent phys 704512 log 4096 len 4352
 26717(f): expecting 704512 actual extent phys 720896 log 4096 len 8192
 26717(f): expecting 729088 actual extent phys 761856 log 12288 len 576
 26718(f): expecting 741376 actual extent phys 770048 log 12288 len 7104
 26719(f): expecting 522240 actual extent phys 753664 log 512 len 8192
 26719(f): expecting 761856 actual extent phys 778240 log 8704 len 8192
 26719(f): expecting 786432 actual extent phys 802816 log 16896 len 8192
 26719(f): expecting 811008 actual extent phys 876544 log 25088 len 512
 26722(f): expecting 712704 actual extent phys 786432 log 2048 len 4096
 26733(f): expecting 753664 actual extent phys 811008 log 4096 len 64
 26735(f): expecting 770048 actual extent phys 827392 log 4096 len 448
 26743(f): expecting 802816 actual extent phys 868352 log 8192 len 448
 26756(f): expecting 765952 actual extent phys 843776 log 2048 len 4608
 26858(f): expecting 827392 actual extent phys 901120 log 4096 len 2560
 26861(f): expecting 901120 actual extent phys 925696 log 8192 len 3072
 26874(f): expecting 835584 actual extent phys 909312 log 4096 len 5184
 26875(f): expecting 876544 actual extent phys 917504 log 4096 len 8192
 26875(f): expecting 925696 actual extent phys 933888 log 12288 len 24576
 26875(f): expecting 958464 actual extent phys 966656 log 36864 len 8192
 26875(f): expecting 974848 actual extent phys 983040 log 45056 len 2304
 26876(f): expecting 823296 actual extent phys 958464 log 2048 len 8192
 26876(f): expecting 966656 actual extent phys 974848 log 10240 len 8192
 26876(f): expecting 983040 actual extent phys 999424 log 18432 len 32768
 26876(f): expecting 1040384 actual extent phys 1097728 log 59392 len 32768
 26901(f): expecting 1572864 actual extent phys 1613824 log 8192 len 32768
 26902(f): expecting 1712128 actual extent phys 1720320 log 8192 len 8192
 26902(f): expecting 1728512 actual extent phys 1736704 log 16384 len 512
 26903(f): expecting 1720320 actual extent phys 1728512 log 8192 len 8192
 26903(f): expecting 1736704 actual extent phys 1744896 log 16384 len 32768
 26903(f): expecting 1818624 actual extent phys 1826816 log 90112 len 32768
 26903(f): expecting 2097152 actual extent phys 2129920 log 360448 len 32768
 26904(f): expecting 2342912 actual extent phys 2351104 log 139264 len 32768
 26904(f): expecting 2621440 actual extent phys 2662400 log 409600 len 32768
 26905(f): expecting 2752512 actual extent phys 2768896 log 40960 len 8192
 26905(f): expecting 2777088 actual extent phys 2785280 log 49152 len 2880
 26906(f): expecting 831488 actual extent phys 2752512 log 2048 len 6272
 26907(f): expecting 884736 actual extent phys 2760704 log 4096 len 8192
 26907(f): expecting 2768896 actual extent phys 2777088 log 12288 len 8192
 26907(f): expecting 2785280 actual extent phys 2793472 log 20480 len 24576
 26907(f): expecting 2818048 actual extent phys 2826240 log 45056 len 8192
 26907(f): expecting 2834432 actual extent phys 2850816 log 53248 len 1408
 26908(f): expecting 843776 actual extent phys 2818048 log 2048 len 8192
 26908(f): expecting 2826240 actual extent phys 2842624 log 10240 len 8192
 26908(f): expecting 2850816 actual extent phys 2859008 log 18432 len 8192
 26908(f): expecting 2867200 actual extent phys 2875392 log 26624 len 5568
 26909(f): expecting 892928 actual extent phys 2867200 log 4096 len 8192
 26909(f): expecting 2875392 actual extent phys 2883584 log 12288 len 32768
 26909(f): expecting 2957312 actual extent phys 2965504 log 86016 len 31104
 26940(f): expecting 3006464 actual extent phys 3014656 log 8192 len 8192
 26941(f): expecting 909312 actual extent phys 3006464 log 4096 len 8192
 26941(f): expecting 3014656 actual extent phys 3031040 log 12288 len 4096
 27217(f): expecting 3031040 actual extent phys 3039232 log 8192 len 8192
 27218(f): expecting 933888 actual extent phys 3047424 log 4096 len 8192
 27218(f): expecting 3055616 actual extent phys 3063808 log 12288 len 4096
 28709(f): expecting 3063808 actual extent phys 3072000 log 8192 len 32768
 28709(f): expecting 3145728 actual extent phys 3178496 log 81920 len 14911
 28748(f): expecting 3227648 actual extent phys 3235840 log 24576 len 8192
 28748(f): expecting 3244032 actual extent phys 3252224 log 32768 len 3264
 28749(f): expecting 872448 actual extent phys 3227648 log 2048 len 8192
 28749(f): expecting 3235840 actual extent phys 3244032 log 10240 len 8192
 28749(f): expecting 3252224 actual extent phys 3268608 log 18432 len 7424
 28750(f): expecting 991232 actual extent phys 3260416 log 4096 len 8192
 28750(f): expecting 3268608 actual extent phys 3276800 log 12288 len 32768
 28750(f): expecting 3350528 actual extent phys 3358720 log 86016 len 32768
 28750(f): expecting 3440640 actual extent phys 3448832 log 167936 len 8192
 28750(f): expecting 3457024 actual extent phys 3465216 log 176128 len 3328
 28751(f): expecting 880640 actual extent phys 3440640 log 2048 len 8192
 28751(f): expecting 3448832 actual extent phys 3457024 log 10240 len 8192
 28751(f): expecting 3465216 actual extent phys 3473408 log 18432 len 32768
 28751(f): expecting 3506176 actual extent phys 3514368 log 51200 len 11328
 29694(f): expecting 868352 actual extent phys 995328 log 1024 len 4096
 29694(f): expecting 999424 actual extent phys 3506176 log 5120 len 1281
 29781(f): expecting 888832 actual extent phys 1044480 log 2048 len 1091
 32235(f): expecting 164896 actual extent phys 848864 log 16 len 1
 35722(f): expecting 1301728 actual extent phys 1564224 log 32 len 1
 37915(f): expecting 1697376 actual extent phys 1703872 log 32 len 1
 38791(d): expecting  12722 actual extent phys  12733 log 1 len 2
 39741(f): expecting 2660352 actual extent phys 3530752 log 2048 len 6594
 39758(f): expecting 2791424 actual extent phys 3538944 log 2048 len 3355
 39885(f): expecting 2859008 actual extent phys 3547136 log 4096 len 2304
 39910(d): expecting  12746 actual extent phys  12815 log 1 len 2
 39912(d): expecting  12748 actual extent phys  13085 log 1 len 4
 39912(d): expecting  13089 actual extent phys  13203 log 5 len 4
 39912(d): expecting  13207 actual extent phys  13214 log 9 len 2
 45373(d): expecting  13343 actual extent phys  13398 log 1 len 2
 45374(d): expecting  13344 actual extent phys  13622 log 1 len 2
 45374(d): expecting  13624 actual extent phys  13754 log 3 len 4
 45374(d): expecting  13758 actual extent phys  13771 log 7 len 1
 50533(f): expecting 3588096 actual extent phys 3620864 log 4096 len 716
 53476(f): expecting 3603456 actual extent phys 3624960 log 256 len 1
 54628(f): expecting 392128 actual extent phys 3625952 log 16 len 1
 54735(f): expecting 3706880 actual extent phys 3719168 log 2048 len 110
 55334(d): expecting  14211 actual extent phys  14223 log 1 len 7
 55334(d): expecting  14230 actual extent phys  14273 log 8 len 1
 55334(d): expecting  14274 actual extent phys  14311 log 9 len 4
 55337(d): expecting  14214 actual extent phys  14335 log 1 len 2
 55337(d): expecting  14337 actual extent phys  14339 log 3 len 3
 55337(d): expecting  14342 actual extent phys  14343 log 6 len 1
 55337(d): expecting  14344 actual extent phys  14395 log 7 len 1
 55337(d): expecting  14396 actual extent phys  14402 log 8 len 1
 55337(d): expecting  14403 actual extent phys  14553 log 9 len 1
 55337(d): expecting  14554 actual extent phys  14563 log 10 len 5
 55337(d): expecting  14568 actual extent phys  14578 log 15 len 1
 55341(d): expecting  14218 actual extent phys  20195 log 1 len 2
 55342(d): expecting  14219 actual extent phys  20193 log 1 len 2
 56045(f): expecting 3743744 actual extent phys 3784704 log 16384 len 8192
 56045(f): expecting 3792896 actual extent phys 3899392 log 24576 len 904
 56640(d): expecting  14246 actual extent phys  14337 log 1 len 2
 57351(d): expecting   9347 actual extent phys   9865 log 1 len 2
 59961(d): expecting  14400 actual extent phys  14682 log 1 len 2
 60070(d): expecting  14502 actual extent phys  15906 log 1 len 3
 60071(d): expecting  14503 actual extent phys  16151 log 1 len 2
 60071(d): expecting  16153 actual extent phys  16203 log 3 len 2
 60075(d): expecting  14507 actual extent phys  16342 log 1 len 2
 60359(d): expecting  14548 actual extent phys  14596 log 1 len 2
 64856(d): expecting  15089 actual extent phys  15326 log 1 len 2
 65292(d): expecting  15129 actual extent phys  15352 log 1 len 2
 67752(f): expecting 424832 actual extent phys 3945440 log 16 len 1
 69893(d): expecting  15892 actual extent phys  16035 log 1 len 2
 71050(d): expecting  15919 actual extent phys  16073 log 1 len 2
 72049(d): expecting  16061 actual extent phys  16278 log 1 len 2
 72456(d): expecting  16088 actual extent phys  16236 log 1 len 2
 73732(d): expecting   9364 actual extent phys  11529 log 1 len 2
 75561(d): expecting  16346 actual extent phys  16775 log 1 len 2
 75854(f): expecting 446688 actual extent phys 4003424 log 16 len 1
 76258(d): expecting  16515 actual extent phys  16883 log 1 len 2
 76264(d): expecting  16521 actual extent phys  17977 log 1 len 2
 76268(d): expecting  16525 actual extent phys  18674 log 1 len 2
 76269(d): expecting  16526 actual extent phys  18687 log 1 len 2
 77026(f): expecting 4096000 actual extent phys 4104192 log 49152 len 8192
 77026(f): expecting 4112384 actual extent phys 4128768 log 57344 len 8192
 77026(f): expecting 4136960 actual extent phys 4284416 log 65536 len 1831
 77043(f): expecting 4030464 actual extent phys 4112384 log 1024 len 1852
 77059(f): expecting 4038656 actual extent phys 4120576 log 2048 len 1105
 84262(d): expecting  17361 actual extent phys  17412 log 1 len 2
 86553(d): expecting  17486 actual extent phys  17538 log 1 len 2
 87086(d): expecting  17518 actual extent phys  17646 log 1 len 2
 88404(d): expecting  17603 actual extent phys  17824 log 1 len 2
 88420(d): expecting  17619 actual extent phys  17875 log 1 len 2
 99009(d): expecting  17992 actual extent phys  18095 log 1 len 2
 99013(d): expecting  17996 actual extent phys  18376 log 1 len 2
 99015(d): expecting  17998 actual extent phys  18516 log 1 len 1
 99015(d): expecting  18517 actual extent phys  18518 log 2 len 1
 99019(d): expecting  18002 actual extent phys  18604 log 1 len 8
108604(d): expecting  18794 actual extent phys  19031 log 1 len 2
108610(d): expecting  18800 actual extent phys  20187 log 1 len 2
108614(d): expecting  18804 actual extent phys  20189 log 1 len 2
108615(d): expecting  18805 actual extent phys  20191 log 1 len 2
109846(f): expecting 4288512 actual extent phys 4320768 log 256 len 1
114703(d): expecting   9451 actual extent phys   9452 log 1 len 302
115949(d): expecting  19495 actual extent phys  19585 log 1 len 2
118017(d): expecting  19609 actual extent phys  19660 log 1 len 2
119532(d): expecting  19734 actual extent phys  19750 log 1 len 2
120741(d): expecting  19776 actual extent phys  19918 log 1 len 2
120771(d): expecting  19794 actual extent phys  19811 log 1 len 2
122162(d): expecting  19873 actual extent phys  20084 log 1 len 2
122179(d): expecting  19889 actual extent phys  20161 log 1 len 2
122895(d): expecting   9452 actual extent phys   9754 log 1 len 111
122895(d): expecting   9865 actual extent phys   9875 log 112 len 2
122895(d): expecting   9877 actual extent phys  10010 log 114 len 3
122895(d): expecting  10013 actual extent phys  10039 log 117 len 1
122895(d): expecting  10040 actual extent phys  10041 log 118 len 11
124197(f): expecting 513920 actual extent phys 4328640 log 16 len 1
130091(f): expecting 564608 actual extent phys 4420416 log 16 len 1
139265(d): expecting 532515 actual extent phys 532561 log 1 len 2
139418(d): expecting 532980 actual extent phys 533428 log 1 len 1
139418(d): expecting 533429 actual extent phys 533430 log 2 len 1
139422(d): expecting 532984 actual extent phys 533512 log 1 len 3
139422(d): expecting 533515 actual extent phys 533541 log 4 len 1
139422(d): expecting 533542 actual extent phys 533564 log 5 len 4
142824(d): expecting 533736 actual extent phys 534064 log 1 len 2
142827(d): expecting 533739 actual extent phys 535033 log 1 len 4
142830(d): expecting 533742 actual extent phys 535514 log 1 len 2
142834(d): expecting 533746 actual extent phys 536918 log 1 len 2
142835(d): expecting 533747 actual extent phys 536971 log 1 len 2
150919(d): expecting 534498 actual extent phys 534579 log 1 len 2
152114(d): expecting 534587 actual extent phys 534646 log 1 len 2
153682(d): expecting 534711 actual extent phys 534752 log 1 len 2
155803(d): expecting 534842 actual extent phys 534889 log 1 len 2
156768(d): expecting 534875 actual extent phys 534904 log 1 len 2
156969(d): expecting 534892 actual extent phys 534902 log 1 len 2
157780(f): expecting 4528128 actual extent phys 4554752 log 2048 len 348
158990(d): expecting 534943 actual extent phys 535051 log 1 len 2
158997(d): expecting 534950 actual extent phys 535057 log 1 len 2
158997(d): expecting 535059 actual extent phys 535070 log 3 len 1
159014(d): expecting 534965 actual extent phys 535079 log 1 len 2
159017(d): expecting 534968 actual extent phys 535113 log 1 len 2
159017(d): expecting 535115 actual extent phys 535118 log 3 len 2
159028(d): expecting 534978 actual extent phys 535164 log 1 len 2
159037(d): expecting 534986 actual extent phys 535232 log 1 len 4
159037(d): expecting 535236 actual extent phys 535237 log 5 len 4
159055(d): expecting 535000 actual extent phys 535299 log 1 len 2
159059(d): expecting 535003 actual extent phys 535304 log 1 len 2
159059(d): expecting 535306 actual extent phys 535345 log 3 len 2
159073(d): expecting 535016 actual extent phys 535442 log 1 len 4
159181(d): expecting 535023 actual extent phys 535040 log 1 len 2
163790(d): expecting 535106 actual extent phys 535139 log 1 len 2
165210(d): expecting 535134 actual extent phys 535179 log 1 len 2
166639(f): expecting 4619648 actual extent phys 4620160 log 32 len 1
170682(d): expecting 535260 actual extent phys 535274 log 1 len 2
174697(d): expecting 535373 actual extent phys 535401 log 1 len 4
174698(d): expecting 535374 actual extent phys 535405 log 1 len 2
177953(d): expecting 535494 actual extent phys 535520 log 1 len 3
180225(d): expecting 532525 actual extent phys 532578 log 1 len 2
181856(d): expecting 535530 actual extent phys 535829 log 1 len 2
181856(d): expecting 535831 actual extent phys 536099 log 3 len 1
181856(d): expecting 536100 actual extent phys 536139 log 4 len 1
181856(d): expecting 536140 actual extent phys 536283 log 5 len 1
181860(d): expecting 535534 actual extent phys 536885 log 1 len 8
188421(d): expecting 532590 actual extent phys 532634 log 1 len 2
188421(d): expecting 532636 actual extent phys 532689 log 3 len 1
188421(d): expecting 532690 actual extent phys 532692 log 4 len 1
190179(d): expecting 536938 actual extent phys 536981 log 1 len 2
190188(d): expecting 536947 actual extent phys 536990 log 1 len 5
190198(d): expecting 536957 actual extent phys 537011 log 1 len 2
190747(d): expecting 536977 actual extent phys 536984 log 1 len 4
194667(f): expecting 1294016 actual extent phys 5002592 log 16 len 1
195345(d): expecting 537075 actual extent phys 537108 log 1 len 2
197126(d): expecting 537125 actual extent phys 537703 log 1 len 2
197165(d): expecting 537161 actual extent phys 537783 log 1 len 2
197165(d): expecting 537785 actual extent phys 537796 log 3 len 2
197182(d): expecting 537178 actual extent phys 537898 log 1 len 2
197182(d): expecting 537900 actual extent phys 538071 log 3 len 1
197182(d): expecting 538072 actual extent phys 538128 log 4 len 1
197182(d): expecting 538129 actual extent phys 538359 log 5 len 1
197182(d): expecting 538360 actual extent phys 538411 log 6 len 1
197182(d): expecting 538412 actual extent phys 538514 log 7 len 1
197182(d): expecting 538515 actual extent phys 538577 log 8 len 1
197182(d): expecting 538578 actual extent phys 538909 log 9 len 1
197182(d): expecting 538910 actual extent phys 538994 log 10 len 1
197182(d): expecting 538995 actual extent phys 539144 log 11 len 1
197182(d): expecting 539145 actual extent phys 539151 log 12 len 1
197182(d): expecting 539152 actual extent phys 539163 log 13 len 1
197363(d): expecting 537355 actual extent phys 544238 log 1 len 2
197492(f): expecting 5019136 actual extent phys 5038464 log 32 len 1
197980(f): expecting 5028992 actual extent phys 5041152 log 64 len 1
198415(d): expecting 537525 actual extent phys 537526 log 1 len 22
198416(d): expecting 537526 actual extent phys 537548 log 1 len 2
198416(d): expecting 537550 actual extent phys 537558 log 3 len 2
198416(d): expecting 537560 actual extent phys 537582 log 5 len 4
198416(d): expecting 537586 actual extent phys 537681 log 9 len 1
198416(d): expecting 537682 actual extent phys 537683 log 10 len 7
203063(d): expecting 537695 actual extent phys 537724 log 1 len 2
206133(d): expecting 538029 actual extent phys 539257 log 1 len 4
216081(d): expecting 539535 actual extent phys 539617 log 1 len 2
217967(f): expecting 5081728 actual extent phys 5083456 log 32 len 1
219321(d): expecting 539814 actual extent phys 539819 log 1 len 4
219322(d): expecting 539815 actual extent phys 539854 log 1 len 4
219326(d): expecting 539818 actual extent phys 539858 log 1 len 4
220371(d): expecting 539853 actual extent phys 539862 log 1 len 4
220372(d): expecting 539854 actual extent phys 539866 log 1 len 16
220372(d): expecting 539882 actual extent phys 539924 log 17 len 2
220372(d): expecting 539926 actual extent phys 539943 log 19 len 6
220372(d): expecting 539949 actual extent phys 539964 log 25 len 1
220372(d): expecting 539965 actual extent phys 539966 log 26 len 2
220372(d): expecting 539968 actual extent phys 539971 log 28 len 5
221255(f): expecting 5105664 actual extent phys 5136384 log 2048 len 3093
223509(d): expecting 539889 actual extent phys 539978 log 1 len 2
225129(d): expecting 539977 actual extent phys 539993 log 1 len 5
225129(d): expecting 539998 actual extent phys 540002 log 6 len 3
226133(d): expecting 539983 actual extent phys 540005 log 1 len 2
226137(d): expecting 539986 actual extent phys 540039 log 1 len 2
226141(d): expecting 539989 actual extent phys 540068 log 1 len 2
226144(d): expecting 539991 actual extent phys 540101 log 1 len 2
226165(d): expecting 539993 actual extent phys 540012 log 1 len 4
237618(f): expecting 2655264 actual extent phys 5190112 log 16 len 1
240416(d): expecting 542904 actual extent phys 542938 log 1 len 2
240432(d): expecting 542909 actual extent phys 542959 log 1 len 2
240433(d): expecting 542910 actual extent phys 542963 log 1 len 2
241784(d): expecting 542957 actual extent phys 542961 log 1 len 2
245906(d): expecting 543107 actual extent phys 543118 log 1 len 2
245906(d): expecting 543120 actual extent phys 543137 log 3 len 2
245914(d): expecting 543115 actual extent phys 543120 log 1 len 2
246865(d): expecting 543130 actual extent phys 543151 log 1 len 2
247099(d): expecting 543140 actual extent phys 543149 log 1 len 2
247099(d): expecting 543151 actual extent phys 543168 log 3 len 2
247106(d): expecting 543147 actual extent phys 543153 log 1 len 2
248534(d): expecting 543156 actual extent phys 543166 log 1 len 2
248534(d): expecting 543168 actual extent phys 543186 log 3 len 2
248541(d): expecting 543163 actual extent phys 543170 log 1 len 2
249587(d): expecting 543179 actual extent phys 543203 log 1 len 2
249846(d): expecting 543189 actual extent phys 543199 log 1 len 2
249846(d): expecting 543201 actual extent phys 543231 log 3 len 2
249853(d): expecting 543196 actual extent phys 543201 log 1 len 2
251277(d): expecting 543220 actual extent phys 543229 log 1 len 2
251277(d): expecting 543231 actual extent phys 543296 log 3 len 2
251283(d): expecting 543226 actual extent phys 543233 log 1 len 2
252584(d): expecting 543338 actual extent phys 543591 log 1 len 2
254065(d): expecting 543688 actual extent phys 543689 log 1 len 2
254171(d): expecting 543689 actual extent phys 543838 log 1 len 3
255779(d): expecting 543956 actual extent phys 544015 log 1 len 6
255779(d): expecting 544021 actual extent phys 544025 log 7 len 3
255779(d): expecting 544028 actual extent phys 544032 log 10 len 7
255781(d): expecting 543958 actual extent phys 544021 log 1 len 4
255781(d): expecting 544025 actual extent phys 544028 log 5 len 4
255781(d): expecting 544032 actual extent phys 544039 log 9 len 9
255783(d): expecting 543960 actual extent phys 544060 log 1 len 2
255786(d): expecting 543963 actual extent phys 544093 log 1 len 5
260965(d): expecting 544082 actual extent phys 544234 log 1 len 4
270566(d): expecting 1057112 actual extent phys 1057156 log 1 len 2
274457(d): expecting 1057944 actual extent phys 1058003 log 1 len 2
274458(d): expecting 1057945 actual extent phys 1058300 log 1 len 2
274458(d): expecting 1058302 actual extent phys 1058547 log 3 len 1
274458(d): expecting 1058548 actual extent phys 1058671 log 4 len 1
274458(d): expecting 1058672 actual extent phys 1058736 log 5 len 1
274459(d): expecting 1057946 actual extent phys 1059236 log 1 len 2
274459(d): expecting 1059238 actual extent phys 1059259 log 3 len 1
274459(d): expecting 1059260 actual extent phys 1059261 log 4 len 1
274459(d): expecting 1059262 actual extent phys 1059300 log 5 len 1
274459(d): expecting 1059301 actual extent phys 1059312 log 6 len 1
282892(f): expecting 2960992 actual extent phys 5311424 log 16 len 1
283067(d): expecting 1060283 actual extent phys 1060374 log 1 len 2
283071(d): expecting 1060287 actual extent phys 1060390 log 1 len 2
283076(d): expecting 1060292 actual extent phys 1060420 log 1 len 2
283076(d): expecting 1060422 actual extent phys 1060433 log 3 len 2
283076(d): expecting 1060435 actual extent phys 1060500 log 5 len 4
287981(d): expecting 1060655 actual extent phys 1060714 log 1 len 2
287982(d): expecting 1060656 actual extent phys 1061011 log 1 len 2
287982(d): expecting 1061013 actual extent phys 1061263 log 3 len 1
287982(d): expecting 1061264 actual extent phys 1061347 log 4 len 1
287982(d): expecting 1061348 actual extent phys 1061447 log 5 len 1
287983(d): expecting 1060657 actual extent phys 1061947 log 1 len 2
287983(d): expecting 1061949 actual extent phys 1061970 log 3 len 1
287983(d): expecting 1061971 actual extent phys 1061972 log 4 len 1
287983(d): expecting 1061973 actual extent phys 1062011 log 5 len 1
287983(d): expecting 1062012 actual extent phys 1062023 log 6 len 1
296004(d): expecting 1062994 actual extent phys 1063085 log 1 len 2
296008(d): expecting 1062998 actual extent phys 1063101 log 1 len 2
296013(d): expecting 1063003 actual extent phys 1063131 log 1 len 2
296013(d): expecting 1063133 actual extent phys 1063144 log 3 len 2
296013(d): expecting 1063146 actual extent phys 1063211 log 5 len 4
300906(d): expecting 1063368 actual extent phys 1063653 log 1 len 2
300906(d): expecting 1063655 actual extent phys 1063938 log 3 len 1
300906(d): expecting 1063939 actual extent phys 1064022 log 4 len 1
300906(d): expecting 1064023 actual extent phys 1064114 log 5 len 1
300907(d): expecting 1063369 actual extent phys 1064677 log 1 len 2
300907(d): expecting 1064679 actual extent phys 1064709 log 3 len 1
300907(d): expecting 1064710 actual extent phys 1064714 log 4 len 1
300907(d): expecting 1064715 actual extent phys 1064784 log 5 len 1
300907(d): expecting 1064785 actual extent phys 1064790 log 6 len 1
300907(d): expecting 1064791 actual extent phys 1064809 log 7 len 1
300907(d): expecting 1064810 actual extent phys 1064811 log 8 len 1
309546(d): expecting 1065312 actual extent phys 1065399 log 1 len 2
310606(d): expecting 1065415 actual extent phys 1065543 log 1 len 2
310759(d): expecting 1065536 actual extent phys 1065584 log 1 len 2
311202(d): expecting 1065584 actual extent phys 1065807 log 1 len 2
313586(d): expecting 1066076 actual extent phys 1066135 log 1 len 2
313586(d): expecting 1066137 actual extent phys 1066149 log 3 len 2
313586(d): expecting 1066151 actual extent phys 1066208 log 5 len 4
317650(d): expecting 1066867 actual extent phys 1066878 log 1 len 2
319808(d): expecting 1067370 actual extent phys 1067680 log 1 len 2
319808(d): expecting 1067682 actual extent phys 1067891 log 3 len 1
319808(d): expecting 1067892 actual extent phys 1067937 log 4 len 1
319812(d): expecting 1067374 actual extent phys 1068678 log 1 len 8
328044(d): expecting 1068921 actual extent phys 1068936 log 1 len 2
328049(d): expecting 1068926 actual extent phys 1068954 log 1 len 2
328052(d): expecting 1068929 actual extent phys 1068956 log 1 len 2
328055(d): expecting 1068932 actual extent phys 1068958 log 1 len 2
328057(d): expecting 1068934 actual extent phys 1068960 log 1 len 2
328058(d): expecting 1068935 actual extent phys 1068962 log 1 len 2
328211(d): expecting 1068939 actual extent phys 1068964 log 1 len 2
328212(d): expecting 1068940 actual extent phys 1068966 log 1 len 2
328214(d): expecting 1068942 actual extent phys 1068984 log 1 len 2
328215(d): expecting 1068943 actual extent phys 1068986 log 1 len 2
328216(d): expecting 1068944 actual extent phys 1068988 log 1 len 2
328217(d): expecting 1068945 actual extent phys 1068990 log 1 len 2
328218(d): expecting 1068946 actual extent phys 1068992 log 1 len 2
328220(d): expecting 1068948 actual extent phys 1068994 log 1 len 2
328221(d): expecting 1068949 actual extent phys 1068996 log 1 len 2
328222(d): expecting 1068950 actual extent phys 1068998 log 1 len 2
328223(d): expecting 1068951 actual extent phys 1069000 log 1 len 2
329488(d): expecting 1068969 actual extent phys 1069002 log 1 len 2
329491(d): expecting 1068972 actual extent phys 1069020 log 1 len 2
329494(d): expecting 1068975 actual extent phys 1069022 log 1 len 2
329495(d): expecting 1068976 actual extent phys 1069024 log 1 len 2
329500(d): expecting 1068981 actual extent phys 1069026 log 1 len 2
329502(d): expecting 1068983 actual extent phys 1069028 log 1 len 2
329503(d): expecting 1068984 actual extent phys 1069030 log 1 len 2
330719(d): expecting 1069008 actual extent phys 1069048 log 1 len 2
330721(d): expecting 1069010 actual extent phys 1069050 log 1 len 2
330726(d): expecting 1069015 actual extent phys 1069052 log 1 len 2
330727(d): expecting 1069016 actual extent phys 1069054 log 1 len 2
330728(d): expecting 1069017 actual extent phys 1069056 log 1 len 2
331980(d): expecting 1069036 actual extent phys 1069074 log 1 len 2
331981(d): expecting 1069037 actual extent phys 1069076 log 1 len 2
331982(d): expecting 1069038 actual extent phys 1069078 log 1 len 2
331985(d): expecting 1069041 actual extent phys 1069080 log 1 len 2
333117(d): expecting 1069059 actual extent phys 1069082 log 1 len 2
333118(d): expecting 1069060 actual extent phys 1069084 log 1 len 2
333122(d): expecting 1069064 actual extent phys 1069102 log 1 len 2
333125(d): expecting 1069067 actual extent phys 1069104 log 1 len 2
333127(d): expecting 1069069 actual extent phys 1069106 log 1 len 2
333130(d): expecting 1069072 actual extent phys 1069108 log 1 len 2
333132(d): expecting 1069074 actual extent phys 1069110 log 1 len 2
334377(d): expecting 1069090 actual extent phys 1069128 log 1 len 2
334378(d): expecting 1069091 actual extent phys 1069130 log 1 len 2
334379(d): expecting 1069092 actual extent phys 1069132 log 1 len 2
334380(d): expecting 1069093 actual extent phys 1069134 log 1 len 2
334383(d): expecting 1069096 actual extent phys 1069136 log 1 len 2
334384(d): expecting 1069097 actual extent phys 1069138 log 1 len 2
334386(d): expecting 1069099 actual extent phys 1069140 log 1 len 2
334388(d): expecting 1069101 actual extent phys 1069142 log 1 len 2
335581(d): expecting 1069116 actual extent phys 1069160 log 1 len 2
335582(d): expecting 1069117 actual extent phys 1069162 log 1 len 2
335586(d): expecting 1069121 actual extent phys 1069164 log 1 len 2
335587(d): expecting 1069122 actual extent phys 1069166 log 1 len 2
335588(d): expecting 1069123 actual extent phys 1069168 log 1 len 2
336776(d): expecting 1069152 actual extent phys 1069186 log 1 len 2
336777(d): expecting 1069153 actual extent phys 1069188 log 1 len 2
337942(d): expecting 1069171 actual extent phys 1069190 log 1 len 2
337943(d): expecting 1069172 actual extent phys 1069192 log 1 len 2
337951(d): expecting 1069178 actual extent phys 1069210 log 1 len 2
337953(d): expecting 1069179 actual extent phys 1069212 log 1 len 2
337954(d): expecting 1069180 actual extent phys 1069214 log 1 len 2
337955(d): expecting 1069181 actual extent phys 1069216 log 1 len 2
337957(d): expecting 1069183 actual extent phys 1069218 log 1 len 2
337958(d): expecting 1069184 actual extent phys 1069220 log 1 len 2
339159(d): expecting 1069195 actual extent phys 1069222 log 1 len 2
339161(d): expecting 1069197 actual extent phys 1069224 log 1 len 2
339164(d): expecting 1069200 actual extent phys 1069242 log 1 len 2
339166(d): expecting 1069202 actual extent phys 1069244 log 1 len 2
339170(d): expecting 1069205 actual extent phys 1069246 log 1 len 2
339171(d): expecting 1069206 actual extent phys 1069248 log 1 len 2
339173(d): expecting 1069207 actual extent phys 1069250 log 1 len 2
339175(d): expecting 1069209 actual extent phys 1069252 log 1 len 2
339176(d): expecting 1069210 actual extent phys 1069254 log 1 len 2
340398(d): expecting 1069229 actual extent phys 1069256 log 1 len 2
340399(d): expecting 1069230 actual extent phys 1069274 log 1 len 2
340400(d): expecting 1069231 actual extent phys 1069276 log 1 len 2
340404(d): expecting 1069235 actual extent phys 1069278 log 1 len 2
340406(d): expecting 1069237 actual extent phys 1069280 log 1 len 2
340408(d): expecting 1069239 actual extent phys 1069282 log 1 len 2
341637(d): expecting 1069260 actual extent phys 1069284 log 1 len 2
341640(d): expecting 1069263 actual extent phys 1069302 log 1 len 2
341641(d): expecting 1069264 actual extent phys 1069304 log 1 len 2
341643(d): expecting 1069265 actual extent phys 1069306 log 1 len 2
341644(d): expecting 1069266 actual extent phys 1069308 log 1 len 2
341645(d): expecting 1069267 actual extent phys 1069310 log 1 len 2
341646(d): expecting 1069268 actual extent phys 1069312 log 1 len 2
341647(d): expecting 1069269 actual extent phys 1069314 log 1 len 2
341650(d): expecting 1069272 actual extent phys 1069316 log 1 len 2
341651(d): expecting 1069273 actual extent phys 1069318 log 1 len 2
341652(d): expecting 1069274 actual extent phys 1069320 log 1 len 2
342865(d): expecting 1069289 actual extent phys 1069338 log 1 len 2
342869(d): expecting 1069293 actual extent phys 1069340 log 1 len 2
342873(d): expecting 1069297 actual extent phys 1069342 log 1 len 2
342874(d): expecting 1069298 actual extent phys 1069344 log 1 len 2
342876(d): expecting 1069300 actual extent phys 1069346 log 1 len 2
342877(d): expecting 1069301 actual extent phys 1069348 log 1 len 2
344043(d): expecting 1069324 actual extent phys 1069350 log 1 len 2
344048(d): expecting 1069328 actual extent phys 1069368 log 1 len 2
344049(d): expecting 1069329 actual extent phys 1069370 log 1 len 2
344050(d): expecting 1069330 actual extent phys 1069372 log 1 len 2
344053(d): expecting 1069333 actual extent phys 1069374 log 1 len 2
344055(d): expecting 1069335 actual extent phys 1069376 log 1 len 2
344056(d): expecting 1069336 actual extent phys 1069378 log 1 len 2
345283(d): expecting 1069353 actual extent phys 1069380 log 1 len 2
345284(d): expecting 1069354 actual extent phys 1069382 log 1 len 2
345287(d): expecting 1069357 actual extent phys 1069428 log 1 len 2
345288(d): expecting 1069358 actual extent phys 1069453 log 1 len 1
345288(d): expecting 1069454 actual extent phys 1069455 log 2 len 1
345290(d): expecting 1069360 actual extent phys 1069502 log 1 len 1
345290(d): expecting 1069503 actual extent phys 1069504 log 2 len 1
345291(d): expecting 1069361 actual extent phys 1069512 log 1 len 2
345295(d): expecting 1069365 actual extent phys 1069530 log 1 len 2
345296(d): expecting 1069366 actual extent phys 1069537 log 1 len 2
345297(d): expecting 1069367 actual extent phys 1069559 log 1 len 2
345298(d): expecting 1069368 actual extent phys 1069561 log 1 len 2
347117(d): expecting 1069511 actual extent phys 1069519 log 1 len 2
347898(d): expecting 1069556 actual extent phys 1069563 log 1 len 50
347898(d): expecting 1069613 actual extent phys 1069616 log 51 len 1
347898(d): expecting 1069617 actual extent phys 1069728 log 52 len 4
347898(d): expecting 1069732 actual extent phys 1069958 log 56 len 1
347898(d): expecting 1069959 actual extent phys 1070015 log 57 len 6
348317(f): expecting 5402624 actual extent phys 5414912 log 2048 len 558
Pass 1: Memory used: 405k/3836k (299k/107k), time:  5.58/ 3.23/ 0.85
Pass 1: I/O read: 93MB, write: 0MB, rate: 16.66MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 405k/3904k (299k/107k), time:  4.57/ 2.10/ 1.60
Pass 2: I/O read: 158MB, write: 0MB, rate: 34.54MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 765k/3904k (555k/211k), time: 10.28/ 5.38/ 2.45
Pass 3: Memory used: 765k/3904k (299k/467k), time:  0.01/ 0.01/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 82.37MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 765k/1940k (298k/467k), time:  0.22/ 0.22/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 765k/1420k (554k/211k), time:  1.92/ 1.66/ 0.02
Pass 5: I/O read: 1MB, write: 0MB, rate: 0.52MB/s

  358197 inodes used (17.08%)
      55 non-contiguous files (0.0%)
     272 non-contiguous directories (0.1%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 338562/31
 5086544 blocks used (60.64%)
       0 bad blocks
       1 large file

  303132 regular files
   33428 directories
      69 character device files
      26 block device files
       7 fifos
     626 links
   21523 symbolic links (19489 fast symbolic links)
       3 sockets
--------
  358814 files
Memory used: 765k/1420k (554k/211k), time: 12.43/ 7.28/ 2.47
I/O read: 253MB, write: 0MB, rate: 20.36MB/s
