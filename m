From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 07:59:21 +0000
Message-ID: <8239molspy.fsf@mid.bfk.de>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.bfk.de ([193.227.124.2]:34120 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab1COIG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 04:06:58 -0400
In-Reply-To: <4D7E7C7F.1040509@redhat.com> (Eric Sandeen's message of "Mon\, 14 Mar 2011 15\:37\:19 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sandeen:

> No, because htree (dir_index) dirs returns names in hash-value
> order, not inode number order.  i.e. "at random."
>
> As you say, sorting by inode number will work much better...

The dpkg folks tested this and it turns out that you get better
results if you open the file and use FIBMAP to get the first block
number, and sort by that.  You could sort by inode number before the
open/fstat calls, but it does not seem to help much.

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
