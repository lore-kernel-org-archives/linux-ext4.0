From: Stephan Kulow <coolo@suse.de>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 07:31:51 +0200
Message-ID: <200907170731.51212.coolo@suse.de>
References: <200907161331.17623.coolo@suse.de> <20090717011219.GE8508@mit.edu> <20090717043241.GA4207@webber.adilger.int>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:40560 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431AbZGQFbz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 01:31:55 -0400
In-Reply-To: <20090717043241.GA4207@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 17 July 2009 06:32:42 Andreas Dilger wrote:

Hi,

> It seems quite odd to me that mballoc didn't find enough contiguous
> free space for this relatively small file.  It might be worthwhile
> to look at (though not necessarily post) the output from the file
> /sys/fs/ext4/{dev}/mb_groups (or "dumpe2fs" has equivalent data)
> and see if there are groups with a lot of contiguous free space.
> In the mb_groups file this would be numbers in the 2^{high} column.

I'm not sure what you expect with "a lot", so I pasted the full file (that 
happens to be in /proc/fs here): http://ktown.kde.org/~coolo/sda6
>
> I don't agree that flex_bg is necessary to have good block allocation,
> since we do get about 125MB per group.  Maybe mballoc is being
> constrained to look at too few block groups in this case?  Looking at
> /sys/fs/ext4/{dev}/mb_history under the "groups" column will tell how
> many groups were scanned to find that allocation, and the "original"
> and "result" will show group/grpblock/count@logblock for recent writes.
>
> $ dd if=/dev/zero of=/myth/tmp/foo bs=1M count=1
>
> pid   inode    original             goal                  result
> 4423  110359   3448/14336/256@0     1646/18944/256@0      1646/19456/256@0
>
> You might also try to create a new temp directory elsewhere on the
> filesystem, copy the file over to the temp directory, and then see
> if it is less fragmented in the new directory.
>
cp /usr/bin/gimp-2.6{.defrag}:

31548 106916   13/0/1142@0             13/0/1024@0             13/24152/59@0           
201   1     2  1056        0     0     
31548 106916   13/24211/1083@59        13/24211/965@59         13/26192/41@59          
201   1     2  1568        0     0     
31548 106916   13/26233/1042@100       13/26233/924@100        13/21777/34@100         
201   1     2  1568        0     0     
31548 106916   13/21811/1008@134       13/21811/890@134        13/6688/32@134          
201   1     2  1568        0     0     
31548 106916   13/6720/976@166         13/6720/858@166         13/10944/32@166         
201   1     2  1568        0     0     
31548 106916   13/6720/1@0             13/6720/1@0             13/513/1@0              
1     1     1  1024        0     0     
31548 106916   13/10976/944@198        13/10976/826@198        13/16896/32@198         
201   1     2  1568        0     0     
31548 106916   13/16928/912@230        13/16928/794@230        13/12564/31@230         
201   1     2  1568        0     0     
31548 106916   13/12595/881@261        13/12595/763@261        13/12724/31@261         
201   1     2  1568        0     0     
31548 106916   13/12755/850@292        13/12755/732@292        13/31700/31@292         
201   1     2  1568        0     0     
31548 106916   13/31731/819@323        13/31731/701@323        13/18103/30@323         
201   1     2  1568        0     0     
31548 106916   13/18133/789@353        13/18133/671@353        13/21691/30@353         
201   1     2  1568        0     0     
31548 106916   13/21721/759@383        13/21721/641@383        13/25881/30@383         
201   1     2  1568        0     0     
31548 106916   13/25911/729@413        13/25911/611@413        13/22196/29@413         
201   1     2  1568        0     0     
31548 106916   13/22225/700@442        13/22225/582@442        13/31380/29@442         
201   1     2  1568        0     0     
31548 106916   13/31409/671@471        13/31409/553@471        13/12954/27@471         
201   2     2  1568        0     0     
31548 106916   13/12981/644@498        13/12981/526@498        13/18176/27@498         
201   2     2  1568        0     0     
31548 106916   13/18203/617@525        13/18203/499@525        13/15161/26@525         
201   2     2  1568        0     0     
31548 106916   13/15187/591@551        13/15187/473@551        13/17625/26@551         
201   2     2  1568        0     0     
31548 106916   13/17651/565@577        13/17651/447@577        13/19936/26@577         
201   2     2  1568        0     0     
31548 106916   13/19962/539@603        13/19962/421@603        13/20247/26@603         
201   2     2  1568        0     0     
31548 106916   13/20273/513@629        13/20273/395@629        13/23515/26@629         
201   2     2  1568        0     0     
31548 106916   13/23541/487@655        13/23541/369@655        13/9949/25@655          
201   2     2  1568        0     0     
31548 106916   13/9974/462@680         13/9974/344@680         13/19832/25@680         
201   2     2  1568        0     0     
31548 106916   13/19857/437@705        13/19857/319@705        13/29244/25@705         
201   2     2  1568        0     0     
31548 106916   13/29269/412@730        13/29269/294@730        13/1344/24@730          
201   2     2  1568        0     0     
31548 106916   13/1368/388@754         13/1368/270@754         13/11776/23@754         
201   2     2  1568        0     0     
31548 106916   13/11799/365@777        13/11799/247@777        14/3104/26@777          
201   2     2  1568        0     0     
31548 106916   14/3130/339@803         14/3130/221@803         14/9984/50@803          
201   1     2  1568        0     0     
31548 106916   14/10034/289@853        14/10034/171@853        14/11264/46@853         
201   1     2  1568        0     0     
31548 106916   14/11310/243@899        14/11310/125@899        58/1024/125@899         
11    1     1  1568        125   128   
31548 106916   58/1149/118@1024        58/1149/1024@1024       
58/17408/445@1024       201   2     2  1568        0     0 

filefrag: 59 extents.

cp /usr/bin/gimp-2.6 /tmp/nd/

25449 650578   80/0/1@0                80/0/1@0                80/589/1@0              
4     1     1  0           0     0

Filesystem type is: ef53
File size of /tmp/nd/gimp-2.6 is 4677400 (1142 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  2638592             588 
   1     588  2628896  2639179    436 
   2    1024  2637846  2629331    118 eof
/tmp/nd/gimp-2.6: 3 extents found

Greetings, Stephan
