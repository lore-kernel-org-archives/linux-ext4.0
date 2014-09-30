From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: ext4: 3.17? problems
Date: Tue, 30 Sep 2014 20:18:01 -0300
Message-ID: <20140930231801.GB729@khazad-dum.debian.net>
References: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
 <20140930210108.GB14283@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140930210108.GB14283@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 30 Sep 2014, Pavel Machek wrote:
> > > So I had to hard power-down the machine. That should be perfectly
> > > safe, as ext4 has a journal, and this is plain SATA disk, right?
> >   Yes, it should be safe.
> 
> Good.

...

> Is there some phase during shutdown where journalling no longer
> protects fs integrity?

Hmm... what kind of backing device?  Because I have Crucial/Micron M500 SSDs
here that _always_ complain (in a SMART counter/attribute) that they have
been subject to a sudden poweroff *when subject to a normal system
shutdown*.

This is scaring me a great deal.  Are we doing something different for SSDs
in the scsi-sd or libata shutdown paths?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
