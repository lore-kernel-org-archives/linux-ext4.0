From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Mon, 15 Feb 2010 07:13:49 +0100
Message-ID: <20100215061349.GB30897@develbox.linuxbox.cz>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz>
 <20100122213827.GH21263@thunk.org>
 <20100124071943.GA4407@nik-comp.linuxbox.cz>
 <20100124094853.GA4382@thunk.org>
 <20100126204754.GA4637@nik-comp.linuxbox.cz>
 <4B60A4A6.3070001@redhat.com>
 <20100128172442.GA531@develbox.linuxbox.cz>
 <4B61D4A2.5020407@redhat.com>
 <20100128183639.GA546@develbox.linuxbox.cz>
 <4B736B20.4070703@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, tytso@mit.edu,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	mzik@linuxbox.cz
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B736B20.4070703@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
I'm sorry for late reply. I did a lot of new tests, and during it, I
noticed that one of chips gets quite hot during them (and of course it's
one without fan, and certainly one without temperature sensor, as none
of temperature sensors shown any suspicious value).
So we replaced case with few more additional fans, and since that, I didn't
get any crash. So I'm really very sorry, seems like it could have been
overheating problem all the time. I just checked CPU/general temperatures
first, so I didn't notice. I'll investigate further on the production machine,
we got those problems first and report if I find anything of interest.
with best regards
nik



On Thu, Feb 11, 2010 at 11:27:44AM +0900, Tejun Heo wrote:
> On 01/29/2010 03:36 AM, Nikola Ciprich wrote:
> > Nope, anything. That's why I first posted it to ext4 list, but now it
> > seems to me it might be hw related...
> 
> Maybe testing on raw block device is a good idea to rule out the
> filesystem?
> 
> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
