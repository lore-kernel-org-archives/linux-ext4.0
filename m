From: Richard Weinberger <richard@nod.at>
Subject: Re: vmalloc with GFP_NOFS
Date: Tue, 24 Apr 2018 21:03:43 +0200
Message-ID: <3732370.1623zxSvNg@blindfold>
References: <20180424162712.GL17484@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="nextPart26752059.sMrGihSObH"
Content-Transfer-Encoding: 7Bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	cluster-devel@redhat.com, Marek Vasut <marek.vasut@gmail.com>,
	linux-ext4@vger.kernel.org, Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Philippe Ombredanne <pombredanne@nexb.com>, linux-mtd@lists.infradead.org,
	Brian Norris <computersforpeace@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Anna Schumaker <anna.schumaker@netapp.com>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180424162712.GL17484@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--nextPart26752059.sMrGihSObH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 24. April 2018, 18:27:12 CEST schrieb Michal Hocko:
> fs/ubifs/debug.c

This one is just for debugging.
So, preallocating + locking would not hurt much.

> fs/ubifs/lprops.c

Ditto.

> fs/ubifs/lpt_commit.c

Here we use it also only in debugging mode and in one case for
fatal error reporting.
No hot paths.

> fs/ubifs/orphan.c

Also only for debugging.
Getting rid of vmalloc with GFP_NOFS in UBIFS is no big problem.
I can prepare a patch.

Thanks,
//richard

--nextPart26752059.sMrGihSObH
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Hack'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Am Dienstag, 24. April 2018, 18:27:12 CEST schrieb Michal Hocko:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; fs/ubifs/debug.c</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">This one is just for debugging.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">So, preallocating + locking would not hurt much.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; fs/ubifs/lprops.c</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Ditto.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; fs/ubifs/lpt_commit.c</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Here we use it also only in debugging mode and in one case for</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">fatal error reporting.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">No hot paths.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; fs/ubifs/orphan.c</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Also only for debugging.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Getting rid of vmalloc with GFP_NOFS in UBIFS is no big problem.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I can prepare a patch.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Thanks,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">//richard</p></body></html>
--nextPart26752059.sMrGihSObH--
