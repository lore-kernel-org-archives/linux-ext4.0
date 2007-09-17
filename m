From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: Ext4 devel interlock meeting minutes (Sep 10, 2007)
Date: Mon, 17 Sep 2007 15:53:36 +0200
Message-ID: <46EE86E0.5000206@bull.net>
References: <20070913103210.62e26236@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47035 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbXIQNyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2007 09:54:44 -0400
In-Reply-To: <20070913103210.62e26236@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jose,

thank you for these minutes for those who were
not online (me,...) !

To be continued today with Mingming's agenda.


jean-pierre


Jose R. Santos a =E9crit :
> Attendees: Dave Kleikamp, Andreas Dilger, Jose Santos, Aneesh Kumar,
> Eric Sandeen
>
> - Lack of e2fsprogs support for some of the features is viewed as the
> major roadblocks for declaring ext4 stable.  There was talk about
> creating a forked version of the tools to only support ext4 while we
> wait for other features to be implemented in Ted's e2fsprogs tree.
> The goal of this version is to provide users with the means of creati=
ng
> and fsck ext4 filesystems in order to increase test coverage.  Such
> version would probably not export any libraries and thus not worry
> about ABI breakage issues.
>
> - Most filesystem layout changes are already in the patch queue so
> filesystem format is stable.  Other major features are in memory
> changes and thus can be changed/improve/debug after dev status is
> removed.
>
> - Andres express interest in Avantika's automated testing to see if i=
t
> was possible to test different permutation of features to test breaka=
ge
> of the ext4 code.
>
> - Jose to post FLEX_BG kernel patch for inclusion into the patch
> queue.  Inode and block allocation changes are memory only, so they c=
an
> be added after removal of dev status.
>
> - Lost of talk about the process sending patches to MM before sending
> patches for Linus during the merge window.  Eric pointed out that if
> nobody was testing ext4 in mm, then this hole exercise is mostly a
> wasted effort.  Andreas and Shaggy pointed out Andrews concerns about
> patches not in mm during the last merge window.  Shaggy pointed out
> that Ted's git tree is not always up to date to the latest ext4 patch
> queue and that someone need to regularly maintain a git tree Andrew c=
an
> pull from.
>
> - Even though attendance was low Andreas suggested that a meeting
> notice be sent since a lot of good discussion was made.  Everybody
> agree but, nobody took meeting notes and nobody volunteered. :)
>
> Apologies if I left out something important.
>
> -JRS
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  =20
