From: Stephan Kulow <coolo@suse.de>
Subject: file allocation problem
Date: Thu, 16 Jul 2009 13:31:17 +0200
Message-ID: <200907161331.17623.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:36271 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755463AbZGPLv2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 07:51:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I played around with ext4 online defrag on 2.6.31-rc3 and noticed a problem. 
The core is this:

# filefrag -v /usr/bin/gimp-2.6 
File size of /usr/bin/gimp-2.6 is 4677400 (1142 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  2884963              29 
   1      29  2890819  2884991     29 
   2      58  2906960  2890847     62 
   3     120  2893864  2907021     29 
   4     149  2898531  2893892     29 
   5     178  2887012  2898559     28 
   6     206  2887261  2887039     27 
   7     233  2888229  2887287     27 
   8     260  2907727  2888255     49 
   9     309  2907811  2907775     90 
  10     399  2889078  2907900     26 
  11     425  2890641  2889103     26 
  12     451  2908065  2890666     31 
  13     482  2908136  2908095     33 
  14     515  2908170  2908168     54 
  15     569  2908257  2908223     31 
  16     600  2908378  2908287     38 
  17     638  2886399  2908415     25 
  18     663  2908646  2886423     26 
  19     689  2909129  2908671     56 
  20     745  2909186  2909184     62 
  21     807  2909281  2909247     31 
  22     838  2902503  2909311     25 
  23     863   103690  2902527    161 
  24    1024   109621   103850    118 eof
/usr/bin/gimp-2.6: 25 extents found

ext4 defragmentation for /usr/bin/gimp-2.6
[1/1]/usr/bin/gimp-2.6: 100%  extents: 25 -> 25 [ OK ]
 Success:                       [1/1]

(filefrag will output very much the same now)

But now the really interesting part starts: when I copy away
that file (as far as I understand the code, e4defrag allocates
space in /usr/bin too), I get:

cp -a /usr/bin/gimp-2.6{,.defrag} (I have 50% free, so I expect it to find 
room):

filefrag -v /usr/bin/gimp-2.6.defrag
File size of /usr/bin/gimp-2.6.defrag is 4677400 (1142 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0   452952              40 
   1      40   439168   452991     32 
   2      72   442912   439199     32 
   3     104   448544   442943     32 
   4     136   449472   448575     32 
   5     168   453920   449503     32 
   6     200   429625   453951     31 
   7     231   430714   429655     31 
   8     262   435296   430744     31 
   9     293   454842   435326     31 
  10     324   436410   454872     29 
  11     353   426832   436438     28 
  12     381   453651   426859     27 
  13     408   447705   453677     25 
  14     433   436510   447729     23 
  15     456   442421   436532     23 
  16     479   451098   442443     23 
  17     502   447082   451120     22 
  18     524   451647   447103     22 
  19     546   437950   451668     21 
  20     567   439293   437970     21 
  21     588   454464   439313     21 
  22     609   455776   454484     21 
  23     630   454624   455796     20 
  24     650   450592   454643     18 
  25     668   451136   450609     18 
  26     686   452305   451153     18 
  27     704   427088   452322     16 
  28     720   427568   427103     16 
  29     736   427952   427583     16 
  30     752   427984   427967     16 
  31     768   650240   427999    256 
  32    1024   634851   650495     69 
  33    1093   633344   634919     49 eof
/usr/bin/gimp-2.6.defrag: 34 extents found

Now that I call fragmented! Calling e4defrag again gives me
34->28 and now it moved _parts_

..
  24     781   478136   480191     56 
  25     837   475850   478191     54 
  26     891  1836751   475903    133 
  27    1024  1875978  1836883    118 eof
/usr/bin/gimp-2.6.defrag: 28 extents found

This looks really strange to me, is this a problem with my very file system or 
a bug?

Greetings, Stephan
