From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: mmc: block: bonnie++ runs with errors on arc/hsdk board
Date: Thu, 15 Mar 2018 09:38:15 -0700
Message-ID: <345e9053-9251-ad27-d05b-ec80b69ee235@synopsys.com>
References: <1520942674.10285.8.camel@synopsys.com>
 <486fe92e-9b53-53a4-f98d-129a97032470@intel.com>
 <1520956602.10285.10.camel@synopsys.com>
 <1521030769.10285.16.camel@synopsys.com>
 <83de0f90-0919-f449-b432-494b9bf524a1@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
 "linux-snps-arc@lists.infradead.org" <linux-snps-arc@lists.infradead.org>,
 "tytso@mit.edu" <tytso@mit.edu>, Vince Weaver <vincent.weaver@maine.edu>,
 Peter Zijlstra <peterz@infradead.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "Eugeniy.Paltsev@synopsys.com" <Eugeniy.Paltsev@synopsys.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Evgeniy Didin
 <Evgeniy.Didin@synopsys.com>
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <83de0f90-0919-f449-b432-494b9bf524a1@intel.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On 03/15/2018 02:27 AM, Adrian Hunter wrote:
> Please try:
> 
> 	perf record -a -e mmc:* -- bonnie++ -u root -r 256 -s 512 -x 1 -d /mnt
> 
> and share the resulting perf.data file when you are able
> to reproduce the hung task message.
> 
> You may want to add this patch first:
> 
> 	https://marc.info/?l=linux-mmc&m=152110580324200

While this SoC has perf counters, Unfortunately the overflow interrupts are not 
wired up. We can do perf stats but not sampling.

Peter was it you or Vince trying to use timer interrupts to emulate perf sampling 
on some ARM SoC ?

Thing is we have a spare hardware timer per core (TIMER1) which is not usabel for 
otherwise gtod function in SMP and could well be repurposed for perf needs.

-Vineet
