From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Tue, 12 Aug 2008 22:32:05 -0400
Message-ID: <20080813023205.GA8232@mit.edu>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <20080811143911.GA6455@skywalker> <20080811181524.GA9769@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37225 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728AbYHMCca (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2008 22:32:30 -0400
Content-Disposition: inline
In-Reply-To: <20080811181524.GA9769@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2008 at 11:45:24PM +0530, Aneesh Kumar K.V wrote:
> On Mon, Aug 11, 2008 at 08:09:12PM +0530, Aneesh Kumar K.V wrote:
> > Can you try this patch ? The patch make group preallocation use the goal
> > block.
> > 
> 
> Results with and without patch.
> 
> http://www.radian.org/~kvaneesh/ext4/lg-fragmentation/
> 

My results match yours; seems to be a bit better, but it's not fixing
the fundamental problem.  With the patch:

 26524: expecting 638190 actual extent phys 631960 log 1 len 1
 26527: expecting 638191 actual extent phys 631963 log 1 len 1
 26533: expecting 638192 actual extent phys 631976 log 1 len 5
 26534: expecting 638193 actual extent phys 631981 log 1 len 2
 26536: expecting 638194 actual extent phys 631984 log 1 len 6
 26538: expecting 638195 actual extent phys 631991 log 1 len 5
 26540: expecting 638196 actual extent phys 631997 log 1 len 2
 26545: expecting 638197 actual extent phys 632009 log 1 len 1
 26546: expecting 638198 actual extent phys 632010 log 1 len 6
 26604: expecting 638199 actual extent phys 632156 log 1 len 1

Useing debugfs's stat command to look at the blocks:

26524: (0):638189, (1):631960
26527: (0):638190, (1):631963
26533: (0):638191, (1-5):631976-631980
26534: (0):638192, (1-2):631981-631982
26536: (0):638193, (1-6):631984-631989
26538: (0):638194, (1-5):631991-631995
26540: (0):638195, (1-2):631997-631998
26545: (0):638196, (1):632009
26546: (0):638197, (1-6):632010-632015

Out of curiosity, I also probed the inode numbers that were out of
sequence from above.  They seem to be mostly allocating out of the
numbers used for the second extent, above.  

26526: (0):631961
26526: (0):631962
26528: (0):631964
26529: (0):411742
26530: (0):631965
26531: (0-1):631966-631967
26532: (0-7):631968-631975
26535: (0):631983
26537: (0):631990
26541: (0-7):631999-632006
26542: (0):632007
26543: (0):632008
26544: (0):411743
26547: (0):632016

Inode  Pathname
26524  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.py
26525  /lib/rhythmbox/plugins/lyrics/LyrcParser.py
26526  /lib/rhythmbox/plugins/lyrics/LyricsParse.py
26527  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.pyc
26528  /lib/rhythmbox/plugins/lyrics/WinampcnParser.py
26529  /lib/rhythmbox/plugins/magnatune
26530  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_small.png
26531  /lib/rhythmbox/plugins/magnatune/magnatune.rb-plugin
26532  /lib/rhythmbox/plugins/magnatune/magnatune-prefs.glade
26533  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.pyc
26534  /lib/rhythmbox/plugins/magnatune/__init__.py
26535  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.py
26536  /lib/rhythmbox/plugins/magnatune/magnatune-purchase.glade
26537  /lib/rhythmbox/plugins/magnatune/TrackListHandler.py
26538  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.py
26539  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_tiny.png
26540  /lib/rhythmbox/plugins/magnatune/__init__.pyc
26541  /lib/rhythmbox/plugins/magnatune/magnatune-loading.glade
26542  /lib/rhythmbox/plugins/magnatune/TrackListHandler.pyc
26543  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.pyc
26544  /lib/rhythmbox/plugins/audioscrobbler
26546  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-prefs.glade
26547  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-ui.xml

Looks like we still have some problems with the block allocator...

      	      	    	      	       	    	- Ted
